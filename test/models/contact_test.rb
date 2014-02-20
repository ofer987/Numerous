require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test 'should belong to a ContactType' do
    contact = places(:freddo).contacts.build(directions: '905-889-0000',
                                             name: 'Dan',
                                             direction_type: 'home',
                                             info: 'do not call')
    refute contact.valid?, 'should include contact_type'
  end

  test 'should belong to a Place' do
    contact = Contact.new(directions: '905-889-0000',
                          contact_type: contact_types(:phone),
                          name: 'Dan',
                          direction_type: 'home',
                          info: 'do not call')
    refute contact.valid?, 'should belong to a place'
  end
  
  test 'should have a direction' do
    contact = places(:freddo).contacts.
      build(directions: nil,
            contact_type: contact_types(:phone),
            name: 'Dan',
            direction_type: 'home',
            info: 'do not call')
    refute contact.valid?, 'directions should not be nil'

    contact = places(:freddo).contacts.
      build(directions: '',
            contact_type: contact_types(:phone),
            name: 'Dan',
            direction_type: 'home',
            info: 'do not call')
    refute contact.valid?, 'directions should not be blank'
  end
end
