module IOSpecHelper
  def pretend_file_not_exists(pattern)
    allow(IO).to receive(:read).and_wrap_original do |m, *a|
      # if this isn't a good use for case equality I don't know what is
      pattern === a.first ? raise(Errno::ENOENT) : m.call(*a) # rubocop:disable CaseEquality
    end
  end
end
