class ProductsController < ApplicationController
  before_action :initialize_products
  before_action :initialize_links

  def index
    @products = Product.all.order('name DESC').page(params[:page]).per(6)
    @new = Product.status('New').order('name')
   
      #@category = Category.find(params[:category_id])
       @categories = Category.all 
  end

  def show
    @product = Product.find(params[:id])
  end

  def content_page
    @page = ContentPage.find(params[:id])
  end


  def category
    @products = Category.find(params[:id]).products
  end



  def category_results
  
    #@products = Category.find(params[:id]).products
    #@products =Category.find(params[:category_id])
    
     #@products = Product.find(params:[category_id])
   @products = Category.find(params[:category_id]).products
    #@products = Product.all
     #@products =  Category.friendly.find(params[:id])
   # @products =Product.where (category_id: category_id) if category_id.present?
     #@category = Category.find(params[:category_id])
     
     
      #@products = Product.category_id(params[:category_id])
  end

  def search_results
    
   wildcard_keywords = '%' + params[:search_keywords] + '%'
   #where_category = ' AND category_id = ' + params[:category_id]
   
    @products = Product.where('name LIKE ? OR description LIKE ? ', wildcard_keywords,
                              wildcard_keywords)
 #  @products =  Product.where(category_id: @category)
 #@products =Product.where (category_id: category_id) if category_id.present?
   
  end

  def radio_results
    @products = Product.status(params[:status])
  end

  def create_line_item
    @line_item = LineItem.create
    line_item.product = product.id
    line_item.quantity = params[:quantity]
    line_item.price = product.price
  end

  def save_fav_product
    session[:favourite_product_id] = params[:id]
    redirect_to :back
  end

  def forget_me_bro
    session[:visit_count] = nil
    session[:products] = nil
    session[:customer_id] = nil
    redirect_to :back
  end

  def add_to_cart
    id = params[:id].to_i
    session[:products] ||= []
    session[:products] << id

    redirect_to :back
  end

  def remove_from_cart
    id = params[:id].to_i
    session[:products].delete(id)
    redirect_to :back
  end

  private

  def product_params
    params.require(:product).permit(:name, :price,
                                    :description, :image, stock_quantity,
                                    :category_id, :status)
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end
end
