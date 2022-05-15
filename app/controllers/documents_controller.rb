class DocumentsController < ApplicationController
  # skip_before_action :verify_authenticity_token
  before_action :set_document, only: %i[ show edit update destroy ]

  def ensure_tmp_dir_exists_for(filename)
    puts "ensure"
    Dir.mkdir File.dirname(filename)
    rescue Errno::EEXIST
  end

  # GET /documents or /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1 or /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents or /documents.json
  def create
    
    name = document_params[:name]
    user = document_params[:user]
    type = document_params[:type]

    file_base64 = params[:file]
    decode_base64_content = Base64.decode64(file_base64)
    encoded_name_file = "#{name}#{SecureRandom.hex(3)}.#{type}"
    filename = Rails.root.join(user, encoded_name_file)
    ensure_tmp_dir_exists_for filename
    File.open(filename, 'wb') do |f|
      f.write(decode_base64_content)
    end
    file = File.open(filename)
    
    require "google/cloud/storage"
    bucket_name = "unpdf_st"

    storage = Google::Cloud::Storage.new
    bucket  = storage.bucket bucket_name, skip_lookup: true
    bucket.create_file file, filename
    puts "Uploaded #{name} as #{filename} in bucket #{bucket_name}"
    new_document = { "name" => name, "type" => type, "user" => user, "storage" => filename }
    @document = Document.new(new_document)
    if @document.save
      puts "it saved the document"
    else
      puts @document.errors
    end
    # respond_to do |format|
    #   if @document.save
    #     format.html { redirect_to document_url(@document), notice: "Document was successfully created." }
    #     format.json { render :show, status: :created, location: @document }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @document.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to document_url(@document), notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:name, :type, :user, :storage)
    end
end
