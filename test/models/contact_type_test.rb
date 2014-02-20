require 'test_helper'

class ContactTypeTest < ActiveSupport::TestCase
  test 'name should have a value' do
    ct = ContactType.new(name: nil, description: 'foo')
    refute ct.valid?, 'name should not be nil'
    
    ct = ContactType.new(name: '', description: 'foo')
    refute ct.valid?, 'name should not be blank'
  end

  test 'description should have a value' do
    ct = ContactType.new(name: 'foo', description: nil)
    refute ct.valid?, 'description should not be nil'
    
    ct = ContactType.new(name: 'foo', description: '')
    refute ct.valid?, 'description should not be blank'
  end
end
