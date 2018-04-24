defmodule ElixirTelegram.BotTest do
  use ElixirTelegram.DataCase

  alias ElixirTelegram.Bot

  describe "messages" do
    alias ElixirTelegram.Bot.Message

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bot.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Bot.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Bot.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Bot.create_message(@valid_attrs)
      assert message.text == "some text"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bot.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, message} = Bot.update_message(message, @update_attrs)
      assert %Message{} = message
      assert message.text == "some updated text"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Bot.update_message(message, @invalid_attrs)
      assert message == Bot.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Bot.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Bot.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Bot.change_message(message)
    end
  end
end
