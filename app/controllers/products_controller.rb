class ProductsController < ApplicationController
  def index
   @products = Product.all
  
  end
  
  def currency (amount)
    sprintf("$%.2f",amount)
  end
  
  def show
    
    @product = Product.find (params[:id])         
          
  end

end
 