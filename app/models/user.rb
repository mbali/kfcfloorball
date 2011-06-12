# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :user_matches
  has_many :matches, :through => :user_matches

  attr_accessor :password
  attr_accessor :old_password

  before_save :encrypt_password
  attr_protected :id, :password_hash

  validates_uniqueness_of :login, :message => "Már van ilyen loginú felhasználó"
  validates_presence_of :nick, :message => "A nicknév megadása kötelező"
  validates_presence_of :email, :message => "Az email cím megadása kötelező"
  validates_presence_of :fullname, :message => "Teljes név megadása kötelező"

  after_initialize :init

  def validate
    validate_format_of_email
  end

  def init
    self.role = "team_member" if self.role.blank?
  end

  def self.authenticate(login,password)
    u = find_by_login(login)
    u && u.authenticated?(password) ? u : nil
  end

  def authenticated?(password)
    password_hash == encrypt(password)
  end

  def encrypt(password)
    Digest::MD5.hexdigest(password)
  end

  def encrypt_password
    return if password.blank?
    self.password_hash = encrypt(password)
  end


  def score
    @score, @match_cnt = compute_scores unless @score
    @score
  end

  def match_count
    @score, @match_cnt = compute_scores unless @score
    @match_cnt
  end

  def avg_score
    score == 0 ? 0 : ((score*1.0)/match_count)
  end

  private

  def validate_format_of_email
    if (email.strip =~ /^([^@\s]+)@((?:[-a-z0-9A-Z]+\.)+[a-zA-Z]{2,})$/).nil? && !email.blank?
      errors.add :email, "Az email mező tartalma formailag nem helyes."
    end
  end

  def compute_scores
    s = 0
    mc = 0
    user_matches.each do |um|
      m = um.match
      s += (um.score || 0) + (um.team == "A" ? 1 : -1) *  (m.team_a_score - m.team_b_score)
      mc += 1
    end
    return s, mc
  end
end
