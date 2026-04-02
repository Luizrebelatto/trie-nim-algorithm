import unittest
import ../trie

suite "Trie":
  setup:
    let t = newTrie()
    t.insert("apple")
    t.insert("app")
    t.insert("application")
    t.insert("fred")
    t.insert("band")

  test "search finds inserted words":
    check t.search("app") == true
    check t.search("apple") == true
    check t.search("application") == true
    check t.search("fred") == true
    check t.search("band") == true

  test "search returns false for prefixes that are not words":
    check t.search("ap") == false
    check t.search("tes") == false
    check t.search("appl") == false

  test "search returns false for words not inserted":
    check t.search("cat") == false
    check t.search("orange") == false
    check t.search("") == false

  test "startsWith matches existing prefixes":
    check t.startsWith("app") == true
    check t.startsWith("fre") == true
    check t.startsWith("fr") == true
    check t.startsWith("f") == true
   

  test "startsWith returns false for non-existing prefixes":
    check t.startsWith("cat") == false
    check t.startsWith("z") == false
    check t.startsWith("appx") == false

  test "autocomplete returns all words with given prefix":
    let appResults = t.autocomplete("app")
    check appResults.len == 3
    check "app" in appResults
    check "apple" in appResults
    check "application" in appResults

  test "autocomplete with full word prefix":
    let banResults = t.autocomplete("ban")
    check banResults.len == 1
    check "band" in banResults

  test "autocomplete fred":
    let fredResults = t.autocomplete("fre")
    check fredResults.len == 1
    check "fred" in fredResults

  test "autocomplete returns empty for non-existing prefix":
    check t.autocomplete("cat").len == 0
    check t.autocomplete("z").len == 0

  test "autocomplete with exact word returns that word":
    let result = t.autocomplete("band")
    check result.len == 1
    check "band" in result

  test "empty trie returns no results":
    let empty = newTrie()
    check empty.search("a") == false
    check empty.startsWith("a") == false
    check empty.autocomplete("a").len == 0

  test "insert duplicate word does not create duplicates":
    t.insert("app")
    let results = t.autocomplete("app")
    check results.len == 3
