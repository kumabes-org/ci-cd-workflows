class UserRepository:
    def get_by_id(self, user_id: int):
        # Simula uma chamada real ao banco de dados
        # Em produção, faria uma consulta SQL/ORM aqui
        if user_id == 1:
            return {"id": 1, "name": "Rodrigo Kumabe", "role": "CTO"}
        return None