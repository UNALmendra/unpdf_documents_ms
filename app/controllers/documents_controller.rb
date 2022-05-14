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
    require "google/cloud/storage"
    puts $GOOGLE_APPLICATION_CREDENTIALS
    # name = document_params[:name]
    # user = document_params[:user]
    # type = document_params[:type]
    # storage = document_params[:storage]

    # file_base64 = params[:file]

    # decode_base64_content = Base64.decode64(file_base64)
    # filename = Rails.root.join( user, "#{SecureRandom.hex(3)}.pdf")
    # ensure_tmp_dir_exists_for filename
    # File.open(filename, 'wb') do |f|
    #   f.write(decode_base64_content)
    # end
    # filepath = File.open(filename)

    # @document = Document.new(document_params)
    # project_id = "unpdf-349523"
    
    # # If you don't specify credentials when constructing the client, the client
    # # library will look for credentials in the environment.
    # storage = Google::Cloud::Storage.new project: project_id 

    # # Make an authenticated API request
    # storage.buckets.each do |bucket|
    #   puts bucket.name
    # end


    # # require "google/cloud/storage"
    # # bucket_name = "undpf_st"
    # # file_name = "test2.txt"

    # # storage = Google::Cloud::Storage.new
    # # bucket  = storage.bucket bucket_name, skip_lookup: true
  
    # # bucket.create_file file, file_name
  
    # # puts "Uploaded #{local_file_path} as #{file.name} in bucket #{bucket_name}"

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
