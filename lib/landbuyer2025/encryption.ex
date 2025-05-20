defmodule Landbuyer2025.Encryption do
  @moduledoc "Utilitaire de chiffrement/déchiffrement pour les tokens sensibles."

  @salt "oanda_token_salt"

  def encrypt(nil), do: nil

  def encrypt(plain_text) when is_binary(plain_text) do
    Plug.Crypto.MessageEncryptor.encrypt(plain_text, key(), key(), @salt)
  end

  def decrypt(nil), do: nil

  def decrypt(cipher_text) when is_binary(cipher_text) do
    Plug.Crypto.MessageEncryptor.decrypt(cipher_text, key(), key(), @salt)
  end

  defp key do
    configured_key = Application.fetch_env!(:landbuyer2025, __MODULE__)[:key]
    decode_key!(configured_key)
  end

  defp decode_key!(<<_::binary>> = key) do
    case Base.decode64(key) do
      {:ok, decoded} -> decoded
      :error -> raise "Invalid base64 ENCRYPTION_KEY"
    end
  end
end
