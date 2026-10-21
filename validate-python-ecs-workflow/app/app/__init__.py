from flask import Flask

from app.controllers.user_controller import user_bp


def create_app():
    app = Flask(__name__)
    
    # Registro dos Blueprints (rotas)
    app.register_blueprint(user_bp, url_prefix='/api')
    
    return app