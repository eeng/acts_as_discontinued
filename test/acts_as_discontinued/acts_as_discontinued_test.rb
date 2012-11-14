require 'test/unit'
require 'active_record'
require "#{File.dirname(__FILE__)}/../../lib/acts_as_discontinued"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

def setup_db
  ActiveRecord::Schema.define(version: 1) do
    create_table :products do |t|
      t.column :discontinued_at, :datetime
      t.references :category
    end
    create_table :categories do |t|
      t.column :discontinued_at, :datetime
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Category < ActiveRecord::Base
  acts_as_discontinued
  has_many :products
end

class Product < ActiveRecord::Base
  acts_as_discontinued
  belongs_to :category
end

class ActsAsDiscontinuedTest < Test::Unit::TestCase
  def test_should_set_discontinued_at_when_discontinued!
    assert_not_nil Product.create!.discontinue!.reload.discontinued_at
  end
  
  def test_should_unset_discontinued_at_when_activate!
    p = Product.create! discontinued_at: Time.now
    assert_not_nil p.discontinued_at
    p.activate!
    assert_nil p.reload.discontinued_at
  end
  
  def test_should_provide_active_scope
    2.times { Product.create! }
    Product.create!.discontinue!
    assert_equal 2, Product.active.size
    assert_equal 3, Product.count
  end
  
  def test_should_provide_status_scope
    2.times { Product.create! }
    Product.create!(category: Category.create!).discontinue!
    assert_equal 3, Product.status(:all).size
    assert_equal 2, Product.status(:active).size
    assert_equal 2, Product.status(nil).size
    assert_equal 1, Product.status(:inactive).size
    assert_equal 1, Product.status(:inactive).find(:all, joins: :category).size
  end

  def test_scope_should_work_on_strings
    2.times { Product.create! }
    Product.create!(category: Category.create!).discontinue!
    assert_equal 3, Product.status('all').size
    assert_equal 2, Product.status('active').size
    assert_equal 2, Product.status('').size
    assert_equal 1, Product.status('inactive').size
  end
  
  def test_should_provide_discountinued?
    assert !Product.create!.discontinued?
    assert Product.create!.discontinue!.discontinued?
  end

  def test_should_provide_active?
    assert Product.create!.active?
    assert !Product.create!.discontinue!.active?
  end

  def test_should_provide_active_setter
    p = Product.new
    p.active = false
    assert !p.active?
    p.active = true
    assert p.active?
  end
  
  def test_setter_should_not_update_discontinued_at_if_was_already_discontinued
    p = Product.new active: false
    original_discontinued_at = p.discontinued_at
    assert original_discontinued_at
    p.active = false
    assert_equal original_discontinued_at, p.discontinued_at
  end
  
  def setup
    setup_db
  end
  
  def teardown
    teardown_db
  end
end
