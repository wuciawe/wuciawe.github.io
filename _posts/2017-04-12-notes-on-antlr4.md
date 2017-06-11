---
layout: post
category: [java]
tags: [java, antlr, parser]
infotext: 'ANTLR (ANother Tool for Language Recognition) is a powerful parser generator for reading, processing, executing, or translating structured text or binary files.'
---
{% include JB/setup %}

### Terminology

- __Language__
  A language is a set of valid sentences; sentences are composed of phrases, 
  which are composed of subphrases, and so on.
- __Grammar__
  A grammar formally defines the syntax rules of a language. Each rule in a 
  grammar expresses the structure of a subphrase.
- __Syntax Tree__ or __Parse Tree__
  This represents the structure of the sentence where each subtree root gives 
  an abstract name to the elements beneath it. The subtree roots correspond to 
  grammar rule names. The leaves of the tree are symbols or tokens of the sentence.
- __Token__
  A token is a vocabulary symbol in a language; these can represent a category of 
  symbols such as “identifier” or can represent a single operator or keyword.
- __Lexer__ or __Tokenizer__
  This breaks up an input character stream into tokens. A lexer performs lexical 
  analysis.
- __Parser__
  A parser checks sentences for membership in a specific language by checking the 
  sentence’s structure against the rules of a grammar. The best analogy for parsing 
  is traversing a maze, comparing words of a sentence to words written along the 
  floor to go from entrance to exit.
  
  - __Top-down parser__
  Top-down parsers are goal-oriented and start matching at the rule associated with 
  the coarsest construct, such as program or inputFile. ANTLR generates top-down 
  parsers called ALL(*) that can use all remaining input symbols to make decisions. 
  - __Recursive-descent parser__
  This is a specific kind of top-down parser implemented with a function for each 
  rule in the grammar.
  - __Lookahead Parser__
  Lookahead Parsers use lookahead to make decisions by comparing the symbols that 
  begin each alternative.

### ANTLR4 overview

Programs that recognize languages are called parsers or syntax analyzers.
Syntax refers to the rules governing language membership.

The process of grouping characters into words or symbols (tokens) is called
lexical analysis or simply tokenizing. We call a program that tokenizes the
input a lexer. The lexer can group related tokens into token classes, or token
types, such as  INT (integers),  ID (identifiers),  FLOAT (floating-point numbers),
and so on. The lexers try to match the longest string possible for each token: 

charstream `->` tokenstream `->` terminalnode `->` rulenode `->` parse tree

ANTLR provides support for two tree-walking mechanisms in its runtime
library. By default, ANTLR generates a parse-tree listener interface that
responds to events triggered by the built-in tree walker.

The beauty of the listener mechanism is that it’s all automatic. We don’t have
to write a parse-tree walker, and our listener methods don’t have to explicitly
visit their children.

There are situations, however, where we want to control the walk itself,
explicitly calling methods to visit children. Option `-visitor` asks ANTLR to 
generate a visitor interface from a grammar with a visit method per rule.

### Writing An ANTLR4 Application

#### Grammar

Grammars consist of a header that names the grammar and a set of rules that 
can invoke each other.

The first step to building a language application is to create a grammar that
describes a language’s syntactic rules (the set of valid sentences).

Grammars consist of a set of rules that describe language syntax. There
are rules for syntactic structure like `stat` and `expr` as well as rules for
vocabulary symbols (tokens) such as identifiers and integers.

#### Rule

Since lexing and parsing rules have similar structures, ANTLR allows us to
combine both in a single grammar file. But since lexing and parsing are two
distinct phases of language recognition, we must tell ANTLR which phase is
associated with each rule. Rules starting with a lowercase letter comprise 
the parser rules. Rules starting with an uppercase letter comprise the 
lexical (token) rules.

We separate the alternatives of a rule with the `|` operator, and we can 
group symbols with parentheses into subrules. For example, subrule `('*'|'/')` 
matches either a multiplication symbol or a division symbol.

By default, ANTLR associates operators left to right. We have to manually specify 
the associativity on the operator token using option `assoc` for right 
associativity.

The ANTLR4 supports extended Backus-Naur form (BNF). A left-recursive rule 
is one that either directly or indirectly invokes itself on the left edge of 
an alternative. While ANTLR4 can handle direct left recursion, it can’t 
handle indirect left recursion.

For keywords, operators, and punctuation, we don’t need lexer rules because we 
can directly reference them in parser rules in single quotes like 'while', '\*', 
and '++'. Some developers prefer to use lexer rule references such as MULT 
instead of literal '\*'. That way, they can change the multiply operator character 
without altering the references to MULT in the parser rules. Having both the 
literal and lexical rule  MULT is no problem; they both result in the same token 
type.

ANTLR collects and separates all of the string literals and lexer rules from 
the parser rules. Literals such as  'enum' become lexical rules and go 
immediately after the parser rules but before the explicit lexical rules.

ANTLR lexers resolve ambiguities between lexical rules by favoring the rule 
specified first.

ANTLR puts the implicitly generated lexical rules for literals before explicit 
lexer rules, so those always have priority.

Rules prefixed with fragment can be called only from other lexer rules; they are 
not tokens in their own right.

#### Visitor and Listener

First, we need to label the alternatives of the rules. (The labels can
be any identifier that doesn’t collide with a rule name.) Without labels on the
alternatives, ANTLR generates only one visitor method per rule.

The biggest difference between the listener and visitor mechanisms is that
listener methods are called by the ANTLR-provided walker object, whereas
visitor methods must walk their children with explicit visit calls. Forgetting
to invoke `visit()` on a node’s children means those subtrees don’t get visited.

Listeners and visitors are great because they keep application-specific code
out of grammars, making grammars easier to read and preventing them from
getting entangled with a particular application. For the ultimate flexibility
and control, however, we can directly embed code snippets (actions) within
grammars. These actions are copied into the recursive-descent parser code
ANTLR generates.

To get more precise listener events, ANTLR lets us label the outermost 
alternatives of any rule using the `#` operator.

#### Sharing, Argument and Return

Instead of using temporary storage to share data between event methods, we can 
store those values in the parse tree itself. We can use this tree annotation 
approach with both a listener and a visitor

The easiest way to annotate parse-tree nodes is to use a `Map` that associates 
arbitrary values with nodes. For that reason, ANTLR provides a simple helper 
class called `ParseTreeProperty`.

Besides the sharing approach, information can also be delivered with call stack. 
Native Java call stack: `Visitor` methods return a value of user-defined type. 
If a visitor needs to pass parameters, it must also use one of the next two 
techniques:

- Stack-based: A stack field simulates parameters and return values like the 
Java call stack.

- Annotator: A map field annotates nodes with useful values. Language implementers 
typically call the data structure that holds symbols a symbol table.

#### Action

For now, actions are code snippets surrounded by curly braces. The `members` action 
injects that code into the member area of the generated parser class.

A semantic predicate `{...}?` is a special Boolean-valued action that let us 
selectively deactivate portions of a grammar at runtime. Predicates are Boolean 
expressions that have the effect of reducing the number of choices that the parser 
sees. 

For example, semantic predicate `{$i<=$n}?` evaluates to `true` until we surpass the 
number of integers requested by the sequence rule parameter `n`. False predicates 
make the associated alternative __disappear__ from the grammar and, hence, from the 
generated parser.

We can compute values or print things out on-the-fly during parsing if we don’t 
want the overhead of building a parse tree.

To make the grammar reusable and language neutral, we need to completely avoid 
embedded actions.

#### Island grammar

The island grammars contain multiple languages.

ANTLR provides a well-known lexer feature called `lexical modes` that lets us
deal easily with files containing mixed formats. The basic idea is to have the
lexer switch back and forth between modes when it sees special sentinel
character sequences.

The key is the `TokenStreamRewriter` object that knows how to give altered views
of a token stream without actually modifying the stream.

#### Error recovery

Error recovery is what allows the parser to continue after finding a syntax error.

The parsers perform `single-token insertion` and `single-token deletion` upon 
mismatched token errors if possible. If not, parsers gobble up tokens until they 
think that it has resynchronized and then returns to the calling rule. We can call 
this the `sync-and-return strategy`.

It can throw out tokens only until the lookahead is consistent with something 
that should match after the parser exits from the rule.

ANTLR tries to recover within the rule before falling back on this basic strategy.

For now, we can summarize `recover()` as consuming tokens until it finds one in the 
resynchronization set. The resynchronization set is the union of rule reference 
following sets for all the rules on the invocation stack. The following set for a 
rule reference is the set of tokens that can match immediately following that 
reference and without leaving the current rule.

During recovery, ANTLR parsers avoid emitting cascading error messages That is, 
parsers emit a single error message for each syntax error until they successfully 
recover from that error.

In many cases, ANTLR can recover more intelligently than consuming until the 
resynchronization set and returning from the current rule. It pays to attempt to 
__repair__ the input and continue within the same rule.

##### Recovering from Mismatched Tokens

For every token reference, `T`, in the grammar, the parser invokes `match(T)`. If 
the current token isn’t `T`, `match()` notifies the error listener(s) and attempts 
to resynchronize. To resynchronize, it has three choices. It can delete a token, 
it can conjure one up, or it can punt and throw an exception to engage the basic 
sync-and-return mechanism.

Deleting the current token is the easiest way to resynchronize, if it makes sense 
to do so. If the parser can’t resynchronize by deleting a token, it attempts to 
insert a token instead.

##### Recovering from Errors in Subrules

ANTLR4 now automatically inserts synchronization checks at the start and at the 
loop continuation test to avoid such drastic recovery. The mechanism looks like 
this:

1. Subrule start
   At the start of any subrule, parsers attempt single-token deletion. But, unlike 
   token matches, parsers don’t attempt single-token insertion. ANTLR would have a 
   hard time conjuring up a token because it would have to guess which of several 
   alternatives would ultimately be successful.

2. Looping subrule continuation test
   If the subrule is a looping construct, `(...)*` or `(...)+`, the parser tries to 
   recover aggressively upon error to stay in the loop. After successfully matching 
   an alternative of the loop, the parser consumes until it finds a token consistent 
   with one of these sets:
   - Another iteration of the loop
   -  What follows the loop
   - The resynchronization set of the current

Besides the recognition of tokens and subrules, parsers can also fail to match
semantic predicates.

##### Catching Failed Semantic Predicates

For now, let’s treat semantic predicates like assertions. They specify conditions 
that must be true at runtime for the parser to get past them. If a predicate 
evaluates to false, the parser throws a `FailedPredicateException` exception, which 
is caught by the catch of the current rule.

The parser reports an error and does the generic sync-and-return recovery.

We can change the message from a chunk of code to something a little more readable 
by using the  fail option on the semantic predicate.

It’s worth pointing out a potential flaw in the mechanism. Given that the parser 
sometimes doesn’t consume any tokens during a single recovery attempt, it’s possible 
that overall recovery could go into an infinite loop. If we recover without consuming 
a token and get back to the same location in the parser, we will recover again without 
consuming a token.

ANTLR parsers have a built-in fail-safe to guarantee error recovery terminates. If 
we reach the same parser location and have the same input position, the parser forces 
a token consumption before attempting recovery.

##### Error Alternatives

While these error alternatives can make an ANTLR-generated parser work a little harder 
to choose between alternatives, they don’t in any way confuse the parser. Just like 
any other alternative, the parser matches them if they are consistent with the current 
input.

### Language pattern

The constraints of word order and dependency, derived from natural language,
blossom into four abstract computer language patterns.

- __Sequence__: This is a sequence of elements such as the values in an array
initializer.

- __Choice__: This is a choice between multiple, alternative phrases such as
the different kinds of statements in a programming language.

- __Token dependence__: The presence of one token requires the presence of
its counterpart elsewhere in a phrase such as matching left and right
parentheses.

- __Nested phrase__: This is a self-similar language construct such as nested
arithmetic expressions or nested statement blocks in a programming language.
