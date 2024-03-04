# frozen_string_literal: true

require 'spec_helper'
require 'generator_spec'
require 'generators/loggable_activity/install_templates_generator'

RSpec.describe LoggableActivity::Generators::InstallTemplatesGenerator, type: :generator do
  destination File.expand_path('../tmp', __dir__)

  before do
    prepare_destination
    run_generator
  end

  it 'creates default templates' do
    templates_path = File.join(destination_root, 'app/views/loggable_activity/templates/default')
    expect(File.exist?(templates_path)).to be true
    template_files = Dir.entries(templates_path)
    expect(template_files).to include(/_create.html/)
    expect(template_files).to include(/_show.html/)
    expect(template_files).to include(/_destroy.html/)
    expect(template_files).to include(/_update.html/)
  end

  it 'creates shared templates' do
    templates_path = File.join(destination_root, 'app/views/loggable_activity/templates/shared')
    expect(File.exist?(templates_path)).to be true
    template_files = Dir.entries(templates_path)
    expect(template_files).to include(/_activity_info.html/)
    expect(template_files).to include(/_list_attrs.html/)
    expect(template_files).to include(/_update_attrs.html/)
    expect(template_files).to include(/_updated_relations.html/)
  end

  it 'creates loggable_activity_helper' do
    helpers_path = File.join(destination_root, 'app/helpers/loggable_activity')
    expect(File.exist?(helpers_path)).to be true
    helper_files = Dir.entries(helpers_path)
    expect(helper_files).to include(/activity_helper/)
    expect(helper_files).to include(/routes_helper/)
    expect(helper_files).to include(/router/)
  end

  after(:all) do
    FileUtils.rm_rf(destination_root)
  end
end
