class AddNewSubCategory < ActiveRecord::Migration[6.0]
  def change
    sub = SubCategory.create(title: "Patentability status", category_id: 1)
    sub.stages.create(title: 'Shared with others or posted on Social Media and/or offered to sell it', position: 1)
    sub.stages.create(title: 'Broadly disclosed but did not indicate that it is for sale or collect orders', position: 2)
    sub.stages.create(title: 'Disclosed to technical experts to learn about technology with no offer to sell', position: 3)
    sub.stages.create(title: 'NDA with development partners sent prior to disclosure', position: 4)
    sub.stages.create(title: 'NDA and/or developmental agreement executed with partners', position: 5)
  end
end
