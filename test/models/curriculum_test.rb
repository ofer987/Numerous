require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
  setup do
    @valid_billet = Billet.new do |billet|
      billet.title = "Interesting Story"
      billet.sub_title = "You Should Read This!"
      billet.content = "Lots of interesting things to read here."
      billet.published_at = DateTime.now
    end
  end

  test 'should get resume' do
    cv = Curriculum.new

    refute cv.resume.blank?, 'no curriculum vitae'
  end

  test 'should get cover letter' do
    cv = Curriculum.new

    refute cv.cover_letter.blank?, 'no cover letter'
  end
end
