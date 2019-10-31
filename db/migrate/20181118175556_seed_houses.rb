class SeedHouses < ActiveRecord::Migration[5.2]
  def up
    House.create(name: "Mars", icon_url: "https://cdn.keyforgegame.com/media/houses/Mars_CmAUCXI.png")
    House.create(name: "Shadows", icon_url: "https://cdn.keyforgegame.com/media/houses/Shadows_z0n69GG.png")
    House.create(name: "Untamed", icon_url: "https://cdn.keyforgegame.com/media/houses/Untamed_bXh9SJD.png")
    House.create(name: "Brobnar", icon_url: "https://cdn.keyforgegame.com/media/houses/Brobnar_RTivg44.png")
    House.create(name: "Logos", icon_url: "https://cdn.keyforgegame.com/media/houses/Logos_2mOY1dH.png")
    House.create(name: "Dis", icon_url: "https://cdn.keyforgegame.com/media/houses/Dis_OooSNPO.png")
    House.create(name: "Sanctum", icon_url: "https://cdn.keyforgegame.com/media/houses/Sanctum_lUWPG7x.png")
  end

  def down
    House.delete_all
  end
end
