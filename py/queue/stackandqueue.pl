#!/usr/bin/perl

@stack = ();  #an empty list.    # ()

push (@stack, 1);                # (1)
push (@stack, "Hello");          # (1, "Hello")
print "\@stack: @stack\n";
$value = pop(@stack);            # (1)
print "\value: $value \@stack: @stack\n";
push (@stack, "Hello", "World"); # (1, "Hello", "World");

print "\value: $value \@stack: @stack\n";

@stuff = ("Goodbye", "Cruel", "World");

push (@stack, @stuff);

print "\value: $value \@stack: @stack\n";


@queue = ();  #an empty list.    # ()

push (@queue, 1);                # (1)
push (@queue, "Hello");          # (1, "Hello")
print "\@queue: @queue\n";
$value = shift(@queue);
print "\value: $value \@queue: @queue\n";
push (@queue, "Hello", "World"); # (1, "Hello", "World");

print "\value: $value \@queue: @queue\n";

@stuff = ("Goodbye", "Cruel", "World");

push (@queue, @stuff);

print "\value: $value \@queue: @queue\n";
