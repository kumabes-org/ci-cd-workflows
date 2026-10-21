from unittest.mock import MagicMock
import pytest
from app.services.user_service import UserService

def test_get_user_profile_success():
    # 1. Arrange (Preparação do Mock)
    mock_repository = MagicMock()
    mock_repository.get_by_id.return_value = {
        "id": 1, 
        "name": "Rodrigo Kumabe", 
        "role": "CTO"
    }
    
    service = UserService(mock_repository)

    # 2. Act (Ação)
    result = service.get_user_profile(1)

    # 3. Assert (Validação)
    assert result["id"] == 1
    assert result["name"] == "Rodrigo Kumabe"
    assert result["active"] is True
    mock_repository.get_by_id.assert_called_once_with(1)

def test_get_user_profile_not_found():
    # 1. Arrange
    mock_repository = MagicMock()
    mock_repository.get_by_id.return_value = None
    
    service = UserService(mock_repository)

    # 2 & 3. Act & Assert (Validação de Exceção)
    with pytest.raises(ValueError, match="Usuário não encontrado"):
        service.get_user_profile(99)
    
    mock_repository.get_by_id.assert_called_once_with(99)