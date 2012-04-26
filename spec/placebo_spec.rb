require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Placebo" do
  it "searches parties"# do

 #   parties = Placebo::Party.search('search terms', :start => 100, :limit => 50)
 #   parties.size.should == 0
 #
 # end

    it "gets a party" do

      party = Placebo::Party.find('22450717')
      party.firstName.should == 'adrianpike'

    end

  it "updates a person" do

    # Potential gotcha here: we have to PUT to a "Person", but GET from a "Party".
    party = Placebo::Person.find('23696287')
    party.firstName = 'hoooray'
    party.save.should == true

  end

  it "creates a person" do

    party = Placebo::Person.new({firstName: 'tester'})
    party.lastName = 'tester'
    party.save.should == true

    party.id.should_not == nil

  end

  it "gets an organization"

  it "lets me add a custom field to an existing party with ID" do

    custom_field = Placebo::CustomField.new({
      :party_id => '23696287',
      :label => 'tt_id',
      :text => 'testing12312321'
    })
    custom_field.save.should == true

  end

  it "lets me update a custom field on a party"
  it "lets me remove a custom field on a party"

  it "lets me add a contact to an existing party" do
    party = Placebo::Person.find('23696287')
    party.contacts = {
      :phone => { :phoneNumber => '555555 1234'}
    }
    party.save.should == true
  end

  it "lets me create a new party with contact information" do

    party = Placebo::Person.new({firstName: 'has_contact'})
    party.contacts = {
      :phone => { :phoneNumber => '666 333 1234'},
      :email => { :emailAddress => 'test@internets.com' }
    }
    party.save.should == true

  end

  it "can change contact information"
  it "can remove contact information"

end
