require 'puppet'
require 'fileutils'

Puppet::Reports.register_report(:fail) do
  desc "trivial test"

  def process
    raise 'Oh crap.'
  end

end

