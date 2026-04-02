import std/tables

type
  TrieNode = ref object
    children: Table[char, TrieNode]
    isEnd: bool

  Trie* = ref object
    root: TrieNode

proc newTrieNode(): TrieNode =
  TrieNode(children: initTable[char, TrieNode](), isEnd: false)

proc newTrie*(): Trie =
  Trie(root: newTrieNode())

proc insert*(t: Trie, word: string) =
  var node = t.root
  for ch in word:
    if ch notin node.children:
      node.children[ch] = newTrieNode()
    node = node.children[ch]
  node.isEnd = true

proc search*(t: Trie, word: string): bool =
  var node = t.root
  for ch in word:
    if ch notin node.children:
      return false
    node = node.children[ch]
  return node.isEnd

proc startsWith*(t: Trie, prefix: string): bool =
  var node = t.root
  for ch in prefix:
    if ch notin node.children:
      return false
    node = node.children[ch]
  return true

proc collectWords(node: TrieNode, prefix: string, results: var seq[string]) =
  if node.isEnd:
    results.add(prefix)
  for ch, child in node.children:
    collectWords(child, prefix & ch, results)

proc autocomplete*(t: Trie, prefix: string): seq[string] =
  var node = t.root
  for ch in prefix:
    if ch notin node.children:
      return @[]
    node = node.children[ch]
  var results: seq[string] = @[]
  collectWords(node, prefix, results)
  return results
