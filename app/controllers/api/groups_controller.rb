class API::GroupsController < API::RestfulController
  load_and_authorize_resource only: :show, find_by: :key
  load_resource only: [:upload_photo], find_by: :key
  skip_before_action :authenticate_user!, only: [:index]

  def index
    instantiate_collection { |collection| collection.search_for(params[:q]).order(recent_activity_count: :desc) }
    respond_with_collection
  end

  def count_explore_results
    render json: { count: Queries::ExploreGroups.new.search_for(params[:q]).count }
  end

  def create
    instantiate_resource
    create_action
    respond_with_resource(scope: {current_user: current_user})
  end

  def publish
    service.publish(group: load_resource, params: publish_params, actor: current_user)
    respond_with_resource
  end

  def archive
    service.archive(group: load_resource, actor: current_user)
    respond_with_resource
  end

  def subgroups
    self.collection = load_and_authorize(:group).subgroups.select { |g| can? :show, g }
    respond_with_collection
  end

  def upload_photo
    ensure_photo_params
    service.update group: resource, actor: current_user, params: { params[:kind] => params[:file] }
    respond_with_resource
  end

  private

  def ensure_photo_params
    params.require(:file)
    raise ActionController::UnpermittedParameters.new([:kind]) unless ['logo', 'cover_photo'].include? params.require(:kind)
  end

  def accessible_records
    Queries::ExploreGroups.new
  end

  def publish_params
    { make_announcement: !!params[:make_announcement], identifier: params.require(:identifier) }
  end

  # serialize out the parent with the group
  def resources_to_serialize
    Array(collection || [resource, resource&.parent].compact)
  end
end
