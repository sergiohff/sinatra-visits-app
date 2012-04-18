# -*- encoding: utf-8 -*-
require 'date'
require 'bundler'

Bundler.setup(:default)
Bundler.require

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/visit.db")

class Visit
  include DataMapper::Resource

  property :token,      Serial
  property :company,    String
  property :employee,   String
  property :date,       String
  property :rating,     String
  property :ingress,    String
  property :status,     String
end


DataMapper.auto_upgrade!

get '/' do
  @visit = Visit.all()

  if @visit
    erb :home
  else
    erb :error
  end
end

get '/error' do
  erb :error
end

get '/delete/:token' do
  visit = Visit.get(params[:token])
  visit.destroy unless visit.nil?

  redirect '/'
end

post '/new/visit' do
  @visit = Visit.new(params[:visit])
  if @visit.save
    redirect '/'
  else
    redirect '/error'
  end
end