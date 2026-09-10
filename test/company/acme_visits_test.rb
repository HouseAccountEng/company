require 'test_helper'

# The rest of the tutorial: the visits, a lead filed, and what a gem asks its platform for.
class AcmeVisitsTest < Minitest::Test
  def setup = @account = Acme::Account.new

  # A visit is one stop of a job, at the job's place: it names the job and no place of its own.
  # One booked for any time of the day has no end.
  def test_the_visits_are_walked_the_same_way_and_name_their_job
    visit = @account.visits.upcoming(2.weeks).first

    assert_equal %w[visit-2], @account.visits.upcoming.ids
    assert_nil visit.description
    assert_in_delta 3.days.from_now, visit.starts_at, 60
    assert_nil visit.ends_at
    assert visit.anytime?
    assert_equal 'job-2', visit.job.id
    assert_equal 'Fix the sink', @account.visits.past.first.description
    assert_equal %w[visit-1 visit-2], @account.visits.ids
  end

  # A lead is filed with the same words on every platform, and answers the customer opened for it.
  def test_a_lead_is_filed_with_the_same_words_on_every_platform
    lead = @account.leads.create name: 'Ada', surname: 'Lovelace', phone: '(555) 200-0001',
      email: 'ada@example.com', address: { street: '3 Main St', zip: '27601' },
      description: 'Fix the sink', notes: 'Estimate $100–$200', source: 'Website'

    assert_equal 'lead-1', lead.id
    assert_equal 'customer-3', lead.customer.id
    assert_equal 'Ada', lead.customer.name
    assert_equal '5552000001', lead.customer.phone
  end

  # A kind names what it reads, and a gem asks its platform for exactly those keys, spelled
  # through the `keys` it maps: Acme's business spells its phone the way Housecall Pro does.
  def test_a_gem_asks_its_platform_for_the_keys_the_vocabulary_reads
    assert_equal %i[id description notes created_at scheduled_at completed_at amount],
      Company::Job.node_keys
    assert_equal %i[id name phone_number], Acme::Business.node_keys
  end
end
