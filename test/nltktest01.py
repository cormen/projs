#!/usr/bin/env python
import nltk
from nltk.corpus import treebank
sentence = """At eight o'clock on Thursday morning Arthur didn't feel very good."""
tokens = nltk.word_tokenize(sentence)
tagged = nltk.pos_tag(tokens)
entities = nltk.chunk.ne_chunk(tagged)
t = treebank.parsed_sents('wsj_0001.mrg')[0]
t.draw()

