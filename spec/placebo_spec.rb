require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Placebo" do

  before(:all) do
    @global_party = Placebo::Person.new({firstName: 'tester'})
    @global_party.lastName = 'search'
    @global_party.save.should == true
  end

  after(:all) do

    parties = []
    parties += Placebo::Party.search('tester')
    parties += Placebo::Party.search('has_contact')
    parties.each{|party|
      party.destroy
    }
  end

  it "searches parties" do
    parties = Placebo::Party.search('zcxvnmcvzx')
    parties.size.should == 0

    parties = Placebo::Party.search('tester')
    parties.size.should == 1
    parties.last.firstName.should == 'tester'
  end

    it "gets a party" do

      party = Placebo::Party.find(@global_party.id)
      party.firstName.should == 'tester'

    end

  it "updates a person" do

    # Potential gotcha here: we have to PUT to a "Person", but GET from a "Party".
    party = Placebo::Person.find(@global_party.id)
    party.lastName = 'hoooray'
    party.save.should == true

  end

  it "creates a person" do

    party = Placebo::Person.new({firstName: 'tester'})
    party.lastName = 'tester'
    party.save.should == true

    party.id.should_not == nil

  end

  it "can delete a person" do

    party = Placebo::Party.search('tester').last
    party.destroy.should == true

  end

  it "gets an organization"

  it "lets me add a custom field to an existing party with ID" do

    custom_field = Placebo::CustomField.new({
      :party_id => @global_party.id,
      :label => 'tt_id',
      :text => 'testing12312321'
    })
    custom_field.save.should == true

  end

  it "lets me update a custom field on a party"
  it "lets me remove a custom field on a party"

  it "lets me add a contact to an existing party" do
    party = Placebo::Person.find(@global_party.id)
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

  it "lets me add a note to a party" do

    note = Placebo::HistoryItem.new({
      :party_id => @global_party.id,
      :note => 'Test note'
    })
    note.save.should == true

  end

  it "lets me add a case to a party" do

    my_case = Placebo::Kase.new({
      :party_id => '22450717',
      :name => 'Test case',
      :description => 'An example case'
    })
    my_case.save.should == true

  end

  it "lets me add an opportunity to a party" do

    my_opp = Placebo::Opportunity.new({
      :party_id => '22450717',
      :name => 'Test opp',
      :description => 'An example opp',
      :currency => 'USD',
      :value => '2000.00',
      :milestone => 'test'
    })
    my_opp.save.should == true

  end


end
