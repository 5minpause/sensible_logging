describe RequestId do
  let(:app) { double(:app, call: [200, {}, []]) }

  it 'adds a request id to the env if one does not already exist' do
    env = {}

    status, headers, body = described_class.new(app).call(env)

    expect(env['request_id']).to_not be_nil
    expect(env['request_id']).to eq(headers['X-Request-Id'])
  end

  it 'uses existing request id' do
    existing_request_id = '123ABC'
    env = { 'HTTP_X_REQUEST_ID' => existing_request_id }

    status, headers, body = described_class.new(app).call(env)

    expect(headers['X-Request-Id']).to eq(existing_request_id)
    expect(env['request_id']).to eq(existing_request_id)
  end
end
