module RQRCode
  class ConnectedQRUtil

    # Generate connected QRCode. (binary mode only)
    #
    #   # data   - the string you wish to encode
    #   # args
    #   #   size   - the size of the qrcode (default 4)
    #   #   level  - the error correction level
    #   #   adjust_for_sjis - true: no split sjis multi byte character
    #
    # qrcode_list = RQRCode::ConnectedQRUtil.generate_binary_connected_qrcodes('hello world', size: 1, level: :m)
    #
    def ConnectedQRUtil.generate_binary_connected_qrcodes(data, *args)
      options = extract_options!(args)
      sliced_text = RQRCode::ConnectedQRUtil.slice_data_for_connected_qrcode(data, options)
      parity = RQRCode::ConnectedQRUtil.create_total_text_parity(data)
      sliced_text.map.with_index do |text, number|

        args = { page_number: number, last_page_number: sliced_text.length - 1, mode: :byte_connected, parity: parity }
        RQRCode::QRCode.new(text, options.merge(args))
      end
    end

    # whole data parity value for connected QRCode.
    def ConnectedQRUtil.create_total_text_parity(data)
      data.each_byte.inject(0) { |parity, b| parity ^ b }
    end

    # Slice whole data for connected QRCode.
    #
    #   # data   - the string you wish to encode
    #   # args
    #   #   size   - the size of the qrcode (default 4)
    #   #   level  - the error correction level
    #   #   adjust_for_sjis - true: no split sjis multi byte character
    def ConnectedQRUtil.slice_data_for_connected_qrcode(data, *args)
      options = extract_options!(args)
      capacity = RQRCodeCore::QRMAXDIGITS[options[:level]][:mode_8bit_byte][options[:size] - 1] - 2

      options[:adjust_for_sjis] ? slice_sjis_data(data, capacity: capacity) : slice_data(data, capacity: capacity)
    end

    def ConnectedQRUtil.extract_options!(arr) #:nodoc:
      arr.last.is_a?(::Hash) ? arr.pop : {}
    end

    def ConnectedQRUtil.slice_data(data, capacity:)
      data.each_byte.each_slice(capacity).map { |sliced| sliced.pack('c*') }
    end

    def ConnectedQRUtil.slice_sjis_data(sjis_data, capacity:)
      is_first_char = lambda { |char| (char >= 129 && char <= 159) || (char >= 224 && char <= 239) }

      bytes = sjis_data.each_byte
      sliced_list = []
      while bytes.present?
        next_bytes = bytes.take(capacity)
        if is_first_char.call(next_bytes.last) && next_bytes.length != bytes
          next_bytes = bytes.take(capacity - 1)
        end

        sliced_list << next_bytes.pack('c*')
        bytes = bytes.drop(next_bytes.length)
      end

      sliced_list
    end
  end
end
