require 'test_helper'

class CurriculumTest < ActiveSupport::TestCase
  setup do
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
