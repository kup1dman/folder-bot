module FolderBot
  module Helpers
    module InlineHelper
      def inline_button(button_text, callback_date)
        Telegram::Bot::Types::InlineKeyboardButton.new(text: button_text, callback_data: callback_date)
      end

      def inline_keyboard(button_texts = nil, callback_dates = nil, back_button: {})
        kb = []
        if button_texts && callback_dates
          button_texts.size.times { |i| kb.push(inline_button(button_texts[i], callback_dates[i])) }
          kb = kb.each_slice(2).to_a
        end

        kb.push([inline_button(back_button[:text], back_button[:callback_data])]) unless back_button.empty?

        Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      end
    end
  end
end
