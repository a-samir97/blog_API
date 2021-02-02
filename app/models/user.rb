class User < ApplicationRecord
    # to encrypt password 
    has_secure_password

    has_many :posts , :dependent => :delete_all
    has_many :comments, :dependent => :delete_all

    has_one_attached :image
    
    def get_image_url
        url_for(self.image)
    end

end
