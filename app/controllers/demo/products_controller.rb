# frozen_string_literal: true

module Demo
  class ProductsController < ApplicationController
    before_action :set_demo_product, only: %i[show edit update destroy]

    # GET /demo/products or /demo/products.json
    def index
      @demo_products = Demo::Product.all
    end

    # GET /demo/products/1 or /demo/products/1.json
    def show; end

    # GET /demo/products/new
    def new
      @demo_product = Demo::Product.new
    end

    # GET /demo/products/1/edit
    def edit; end

    # POST /demo/products or /demo/products.json
    def create
      @demo_product = Demo::Product.new(demo_product_params)

      respond_to do |format|
        if @demo_product.save
          format.html { redirect_to demo_product_url(@demo_product), notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @demo_product }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @demo_product.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /demo/products/1 or /demo/products/1.json
    def update
      respond_to do |format|
        if @demo_product.update(demo_product_params)
          format.html { redirect_to demo_product_url(@demo_product), notice: 'Product was successfully updated.' }
          format.json { render :show, status: :ok, location: @demo_product }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @demo_product.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /demo/products/1 or /demo/products/1.json
    def destroy
      @demo_product.destroy!

      respond_to do |format|
        format.html { redirect_to demo_products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_demo_product
      @demo_product = Demo::Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def demo_product_params
      params.require(:demo_product).permit(:name, :part_number, :price)
    end
  end
end
