json = JSON.parse response.body
expect(json.length).to eq(watchable_count)

json = JSON.parse response.body
json.each do |k, v|
  expect(v).to eq w.send(k.to_sym)
end