require_relative '../../lib/user_model'
require 'test/unit'

class TestUserModel < Test::Unit::TestCase
  def setup()
    @user_1 = User.new("test")
    @user_2 = User.new("jimBoB")
    connection = Mongo::Connection.new.db("testdb")
    collection = "testColl"
    @user_model = UserModel.new(connection, collection)
    @db_conn = connection.collection(collection)
  end

  def teardown()
    @db_conn.remove()
  end

  def test_save_user()
    @user_model.save_user(@user_1)
    assert(@db_conn.find_one("_id" => "test"), "Testing that user was added to database.")
  end

  def test_update_user()
    @user_model.save_user(@user_1)
    @user_1.follow_user(@user_2)
    @user_model.save_user(@user_1)
    assert_equal(1, @db_conn.find("_id" => "test").count, "Making sure there is only one record for a user.")
    record = @db_conn.find_one("_id" => "test")
    assert_equal(@user_1.following, Set.new(record["following"]), "Testing that update works correctly.")
  end

  def test_get_user_by_handle()
    @user_model.save_user(@user_2)
    reconstruction = @user_model.get_user_by_handle("jimBoB")
    assert_equal(@user_2.handle, reconstruction.handle, "Testing that handle reconstructs.")
    assert_equal(@user_2.following, reconstruction.following, "Testing that following array reconstructs.")
  end

  def test_user_exists?()
    @user_model.save_user(@user_1)
    assert_equal("test", @user_model.user_exists?("test"), "Testing that we find the exact user string.")
    assert_equal("test", @user_model.user_exists?("TeSt"), "Testing that we still find the user string if the case is mixed up.")
    assert_equal(nil, @user_model.user_exists?("Crazy"), "Testing that an utterly wrong username returns false.")
    assert_equal(nil, @user_model.user_exists?("retested"), "testing that a string with a username in it will not return true.")
  end
end
