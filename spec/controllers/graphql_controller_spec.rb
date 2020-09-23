require 'rails_helper'

RSpec.describe GraphqlController, type: :controller do
  it "loads chapters" do
    query_string = <<-GRAPHQL
      query Chapters {
        chapters {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { })

    expect(result).not_to be_nil
  end

  it "loads juzs" do
    query_string = <<-GRAPHQL
      query Juzs {
        juzs {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { })

    expect(result).not_to be_nil
  end

  it "loads chapter" do
    query_string = <<-GRAPHQL
      query Chapter($id: ID!) {
        chapter(id: $id) {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { id: 1 })

    expect(result).not_to be_nil
  end

  it "loads chapter info" do
    query_string = <<-GRAPHQL
      query ChapterInfo($id: ID!) {
        chapterInfo(id: $id) {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { id: 1 })

    expect(result).not_to be_nil
  end

  it "loads verse" do
    query_string = <<-GRAPHQL
      query Verse($id: ID!) {
        verse(id: $id) {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { id: 1 })

    expect(result).not_to be_nil
  end

  it "loads verse_by_verse_key" do
    query_string = <<-GRAPHQL
      query Verse($verseKey: String!) {
        verseByVerseKey(verseKey: $verseKey) {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { id: '1:1' })

    expect(result).not_to be_nil
  end

  it "loads verses" do
    query_string = <<-GRAPHQL
      query Verses($chapterId: ID!, $language: String, $offset: Int, $padding: Int, $page: Int, $limit: Int) {
        verses(chapterId: $chapterId, language: $language, offset: $offset, padding: $padding, page: $page, limit: $limit) {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { id: 1 })

    expect(result).not_to be_nil
  end

  it "loads words" do
    query_string = <<-GRAPHQL
      query Words($verseId: ID!) {
        words(verseId: $verseId) {
          id
        }
      }
    GRAPHQL

    result = QuranAPISchema.execute(query_string, variables: { id: 1 })

    expect(result).not_to be_nil
  end
end
