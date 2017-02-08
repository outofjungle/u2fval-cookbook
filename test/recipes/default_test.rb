describe package('apache2') do
  it { should be_installed }
end

control 'apache2' do
  impact 1.0
  title 'Verify apache2 service'
  desc 'Ensures apaceh2 service is up and running'
  describe service('apache2') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end
end

describe port(80) do
  it { should be_listening }
end
