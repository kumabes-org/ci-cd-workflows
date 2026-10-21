from flask import Blueprint, jsonify

from app.repositories.user_repository import UserRepository
from app.services.user_service import UserService

user_bp = Blueprint('user_bp', __name__)

# Instanciação direta (pode ser substituída por frameworks de DI como dependency-injector se preferir)
repo = UserRepository()
service = UserService(repo)

@user_bp.route('/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    try:
        user_profile = service.get_user_profile(user_id)
        return jsonify(user_profile), 200
    except ValueError as e:
        return jsonify({"error": str(e)}), 404