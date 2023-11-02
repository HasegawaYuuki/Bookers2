class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update, :destroy]

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      @user = current_user
      render :index
    end
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    }
    @book = Book.new
  end

  def show
    @book = Book.new
    @books = Book.find(params[:id])
    @user = @books.user
    @book_comment = BookComment.new
    read_count = ReadCount.new(book_id: @books.id, user_id: current_user.id)
    #ReadCountを新しく作成し、book_idに取得してきた本のid、user_idにcurrent_user = つまり自分のidを入力
    read_count.save
  end

  def edit
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def update
    is_matching_login_user
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@book.id)
    else
      render :edit
    end

  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    @book = Book.find(params[:id])
    user = @book.user
    unless user.id == current_user.id
      redirect_to books_path
    end
  end
end
