---
layout: post
category: [kafka]
tags: [kafka]
infotext: 'notes on the ISR in kafka, a mechanism for HA and consistence.'
---
{% include JB/setup %}

Days before, some of my Spark Streaming Application failed every night because of facing 
offsets out of range. That was caused by pending too many batches whose root cause is 
the slow speed of pulling data from kafka.

The DevOpt observes that during that range of time, there are more `ISR` events. So what 
the ISR is? Bellow is something related I find for `kafka 0.8`.

### Delivery Semantics

There are three message delivery guarantees:

- __At most once__: messages may be lost but are never redelivered.
- __At least once__: messages are never lost but may be redelivered.
- __Exactly once__: each message is delivered once and only once.

Kafka guarantees at-least-once delivery by default. It also allows the users to implement 
at-most-once delivery by disabling retries on the producer and committing its offset prior 
to processing a batch of messages. Exactly-once delivery requires co-operation with the 
destination storage system.

Above is what the kafka documentation declares. In some situation, it turns out to be 
impossible to achieve at-least-once delivery. I will talk about that soon.

It is extremely hard to achieve at-least-once delivery hard, sometimes even impractice, 
because the producer could fail, the consumer could fail, and the middleware itself could 
fail.

The kafka uses replication to achieve fault tolerance on its own side, provides the 
`commit` for producer to handle the delivery semantics, and `offset` for consumer to handle 
the delivery semantics.

### Replication

Kafka replicates the log for each topic's partitions across a configurable number of servers. 
This allows automatic failover to these replicas when a server in the cluster fails so 
messages remain available in the presence of failures.

The unit of replication is the topic partition. Under non-failure conditions, each partition 
in Kafka has a single leader and zero or more followers. All reads and writes go to the 
leader of the partition.

Followers consume messages from the leader just as a normal Kafka consumer would and apply 
them to their own log.

`ISR` refers to `in-sync` replica, a follower considered `in-sync` must satisfy following 
two conditions:

1 It must send the fetch request in certain time, configurable via `replica.lag.time.max.ms`.
2 It must not lag behind the leader too far away, configurable via `replica.lag.max.messages`.

The leader keeps track of the set of ISR. If a follower dies, gets stuck, or falls behind, 
the leader will remove it from the ISR.

A message is considerred `committed` when all ISR for that partition have applied it to 
their log. Only committed messages are ever given out to consumer.

The leader will remove the out-of-sync replica, so as to prevent the message write latency 
from increasing. As long as the out-of-sync replica is still alive, it keeps pulling 
message from the leader. Once the out-of-sync replica catches up the leader's log end 
offset, it will be added back to the ISR.

### `acks` for Producer

The `acks` property for the kafka producer controls when the producer request is considered 
complete and when the producer receives an acknowledgment from the broker:

- `0`: fire and forget, producer will never wait for an acknowledgement from the broker.
- `1`: producer receives an acknowledgment once the lead replia has received the data.
- `-1`: producer will receive an acknowlegment once the write is `committed`, which means 
all the `ISR`s have received the data.

Note that `-1` does not guarantee that the full set of assigned replicas have received the 
message. By default, it happens as soon as all the current ISR have received the message.

### offset for Consumer

The consumer can do the idempotent updates according to the offset of the message it 
receives to handle the delivery semantics.

### Quorums

In kafka, a node dies when it fails to maintain its session with ZooKeeper (via ZooKeeper's 
heartbeat mechanism).

When the leader dies, we need to choose a new leader from among the followers. The log 
replication algorithm must guarantee that if a message is committed, and the leader fails, 
the new leader must also have that message.

If you choose the number of acknowledgements required and the number of logs that must be 
compared to elect a leader such that there is guaranteed to be an overlap, then this is 
called a `quorum`.

A common approach is to use a majority vote for both the commit decision and the leader 
election. The majority vote approach has a very nice property: the latency is dependent on 
only the fastest servers.

Kafka takes a slightly different approach to choosing its quorum set. It dynamically 
maintains a set of ISR that are caught-up to the leader. Only members of this set are 
eligible for election as leader. A write to kafka partition is not considered committed 
until __all__ `ISR`s have received the write.

#### Unclean leader election

The kafka guarantees with respect to data loss is predicated on at least one replica 
remaining in sync. If all the nodes replicating a partition die, this guarantee no longer 
holds.

There are two choices to recover a new leader:

1 Wait for a replica in the ISR to come back to life and choose this replica as the 
leader (hopefully it still has all its data).
2 Choose the first replica (not necessarily in the ISR) that comes back to life as the 
leader.

This is where even `at-least-once` is hard to guarantee.

#### Availability vs Durability

There is a balance between availability and durability:

- Disable unclean leader election: if all replicas become unavailable, then the partition will 
remain unavailable until the most recent leader becomes available again. This effectively 
prefers unavailability over the risk of message loss.
- Specify a minimum ISR size: the partition will only accept writes if the size of the ISR is 
above a certain minimum, in order to prevent the loss of messages that were written to just a 
single replica, which subsequently becomes unavailable. A lower setting prefers availability 
over consistence.

### Our situation

In our situation, we observe that some replicas are removed and added repeatedly. It means that 
the nodes being alive all the time. There are large lags between leaders and followers. There 
are high latency for the message to be committed because some replicas fail to keep in-sync which 
means messages are waited to be committed.

There is still no clear clue why reading is so slow. Because uncommitted messages are not visible 
to the consumer. And according to the log of my application, in each batch the amount of message 
of partitions do not vary very much and only some partition is slow to read.

### References

[link1](https://kafka.apache.org/documentation/#replication){:target='_blank'}, and
[link2](https://www.confluent.io/blog/hands-free-kafka-replication-a-lesson-in-operational-simplicity/){:target='_blank'}
