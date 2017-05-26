require 'azure_search/errors'

include AzureSearch::Errors

describe RetriableHttpError do
  it 'raises a StandardError' do
    expect { raise RetriableHttpError }.to raise_error(StandardError)
  end

  it 'returns a formatted error message' do
    expect {
      raise RetriableHttpError.new 404, "Not Found"
    }.to raise_error { |err|
      expect(err.code).to eq(404)
      expect(err.message).to eq("Not Found")
      expect(err.to_s).to eq("RetriableHttpError <404>: Not Found")
    }
  end
end
