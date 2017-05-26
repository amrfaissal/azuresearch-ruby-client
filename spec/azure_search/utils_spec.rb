require 'azure_search/utils'

describe AzureSearch do
  let(:dummy_class) {
    Class.new { extend AzureSearch }
  }

  it 'checks if supplied value is a boolean' do
    expect(dummy_class.is_bool?("string")).to eq(false)
    expect(dummy_class.is_bool?(false)).to eq(true)
  end

  it 'checks if supplied string is valid HTML' do
    expect(dummy_class.has_html?("<em>")).to eq(true)
    expect(dummy_class.has_html?("text")).to eq(false)
  end

  it 'converts a Hash to query string' do
    expect(dummy_class.to_query_string({
      :q => "text",
      :includeCount => "true"
      })).to eq("q=text&includeCount=true")
  end
end
