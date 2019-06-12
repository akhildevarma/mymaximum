require 'rails_helper'

# Feature disabled
describe 'topic_searches routes', :ignore do
  it 'routes GET /topic_searches' do
    expect(get: 'topic_searches').to route_to(
      controller: 'topic_searches',
      action: 'index'
    )
  end

  it 'routes GET /topic_searches/new' do
    expect(get: 'topic_searches/new').to route_to(
      controller: 'topic_searches',
      action: 'new'
    )
  end

  it 'routes POST /topic_searches' do
    expect(post: 'topic_searches').to route_to(
      controller: 'topic_searches',
      action: 'create'
    )
  end

  it 'routes GET /topic_searches/:id' do
    expect(get: 'topic_searches/1').to route_to(
      controller: 'topic_searches',
      action: 'show',
      id: '1'
    )
  end

  it 'routes GET /topic_searches/:id/tags' do
    expect(get: 'topic_searches/1/tags').to route_to(
      controller: 'topic_searches',
      action: 'tags',
      id: '1'
    )
  end
end
