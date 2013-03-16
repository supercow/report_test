require 'puppet/face'
require 'puppet/indirector/face'
require 'puppet/util'

Puppet::Face.define(:report_test, '0.0.1') do
  copyright "Puppet Labs", 2013
  license   "Apache 2 license; see COPYING"
  
  summary "Test custom report processors"

  action(:process) do
    default
    summary "Process the specified report"

    option "-p PROCESSOR", "--processor PROCESSOR" do
      required
      summary "A specific processor to test. Runs all configured processors if omitted"
    end

    option "-r REPORT", "--report REPORT" do
      required
      summary "The path to a stored YAML report with will be used to feed the processor"
    end
    
    when_invoked do |options|
      begin
        report = YAML.load_file options[:report]
      rescue Exception => load_error
        Puppet.err "Could not load YAML report #{report}: #{load_error.message}"
        exit 1
      end
      processor = options[:processor]
      Puppet::Transaction::Report.indirection.terminus_class = :processor
      Puppet.settings[:reports] = processor if processor != nil
      begin
        Puppet::Face[:report, '0.0.1'].save report
        Puppet.notice "Report processor \'#{processor}\' executed successfully.\n"
      rescue Exception => e
        Puppet.err "Error running processor \'#{processor}\': #{e.message}\n"
      end
      exit 0
    end
  end
end
  
