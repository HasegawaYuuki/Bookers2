class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = @book.id
    comment.save
    #redirect_back(fallback_location: books_path(@book))
  end

  def destroy
    comment = BookComment.find(params[:id])
    @book = comment.book
    comment.destroy
    #redirect_back(fallback_location: books_path)
  end


  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
