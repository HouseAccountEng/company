require 'test_helper'

# A gem's list answers `each` and `between`, and gets the windows measured from now for free.
class Stops < Company::Collection
  attr_reader :from, :to

  def initialize(from: nil, to: nil)
    @from = from
    @to = to
  end

  def each
    yield Company::Visit.new(node: { id: 'visit-01' })
    yield Company::Visit.new(node: { id: 'visit-02' })
  end

  def between(from, to) = self.class.new(from: from, to: to)
end

class CollectionTest < Minitest::Test
  def test_narrows_to_what_starts_from_now_on_and_that_far_ahead_at_most
    stops = Stops.new.upcoming 2.weeks

    assert_in_delta Time.now, stops.from, 1
    assert_in_delta Time.now + 2.weeks, stops.to, 1
    assert_nil Stops.new.upcoming.to
  end

  def test_narrows_to_what_started_before_now_and_that_far_back_at_most
    stops = Stops.new.past 2.weeks

    assert_in_delta Time.now - 2.weeks, stops.from, 1
    assert_in_delta Time.now, stops.to, 1
    assert_nil Stops.new.past.from
  end

  def test_answers_the_ids_of_every_record_walked
    assert_equal %w[visit-01 visit-02], Stops.new.ids
  end
end
