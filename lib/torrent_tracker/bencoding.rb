module TorrentTracker
  module BEncoding
    class ::String
      # Encodes a string into a bencoded string. BEncoded strings are length-prefixed base ten followed by a colon and
      # the string.
      #
      # "string".bencode #=> "6:string"
      def bencode
        [length, ':', self].join
      end
    end

    class ::Symbol
      # Encodes a symbol into a bencoded string. BEncoded strings are length-prefixed base ten followed by a colon and
      # the string.
      #
      # :symbol.bencode #=> "6:symbol"
      def bencode
        to_s.bencode
      end

      def <=>(o)
        to_s <=> o.to_s
      end
    end

    class ::Numeric
      # Encodes a numeric into a bencoded integer. Bencoded integers are represented by an 'i' followed by the number in
      # base 10 followed by an 'e'. Decimal numbers will be truncated.
      #
      #  3.0.bencode #=> "i3e"
      #  3.6.bencode #=> "i3e"
      # -3.0.bencode #=> "i-3e"
      def bencode
        to_int.bencode
      end
    end

    class ::Integer
      # Encodes an integer into a bencoded integer. Bencoded integers are represented by an 'i' followed by the number
      # in base 10 followed by an 'e'.
      #
      #  3.bencode #=> "i3e"
      # -3.bencode #=> "i-3e"
      def bencode
        [:i, self, :e].join
      end
    end

    class ::Array
      # Encodes an array into a bencoded list. Bencoded lists are encoded as an 'l' followed by their elements (also
      # bencoded) followed by an 'e'.
      #
      # [:eggs, "ham"].bencode #=> "l4:eggs3:hame"
      def bencode
        collect do |element|
          element.bencode
        end.unshift(:l).push(:e).join
      end
    end

    class ::Hash
      # Encodes an array into a bencoded dictionary. Bencoded dictionaries are encoded as a 'd' followed by a list of
      # alternating keys and their corresponding values followed by an 'e'. Keys appear in sorted order.
      #
      # For example, d3:cow3:moo4:spam4:eggse corresponds to {'cow': 'moo', 'spam': 'eggs'} and d4:spaml1:a1:bee corresponds to {'spam': ['a', 'b']}.
      #
      # {:cow => "moo", :seven => 7].bencode #=> "d3:cow3:moo5:seveni7ee"
      def bencode
        keys.sort.collect do |key|
          key.bencode + self[key].bencode if self[key]
        end.unshift(:d).push(:e).join
      end
    end
  end
end