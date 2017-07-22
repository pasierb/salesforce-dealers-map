namespace :salesforce do
  namespace :dealers do
    desc "Import relevant salesforce dealers"
    task :import => :environment do
      SalesforceDealersService.import
    end
  end
end
