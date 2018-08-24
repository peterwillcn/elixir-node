defmodule AecorePeerRLPTest do
  use ExUnit.Case

  alias Aecore.Peers.PeerConnection
  alias Aecore.Chain.Identifier
  @tag :peers
  test "encode and decode RLP test based on epoch binaries" do
    # ping
    assert PeerConnection.rlp_encode(1, ping_object()) == ping_binary()
    assert PeerConnection.rlp_decode(1, ping_binary()) == ping_object()

    # get_header_by_hash
    assert PeerConnection.rlp_encode(3, get_block_and_header_by_hash_object()) ==
             get_block_and_header_by_hash_binary()

    assert PeerConnection.rlp_decode(3, get_block_and_header_by_hash_binary()) ==
             get_block_and_header_by_hash_object()

    # get_n_successors
    assert PeerConnection.rlp_encode(5, get_n_successors_object()) == get_n_successors_binary()

    assert PeerConnection.rlp_decode(5, get_n_successors_binary()) == get_n_successors_object()

    # get_block
    assert PeerConnection.rlp_encode(7, get_block_and_header_by_hash_object()) ==
             get_block_and_header_by_hash_binary()

    assert PeerConnection.rlp_decode(7, get_block_and_header_by_hash_binary()) ==
             get_block_and_header_by_hash_object()

    # get_header_by_height
    assert PeerConnection.rlp_encode(15, get_header_by_height_object()) ==
             get_header_by_height_binary()

    assert PeerConnection.rlp_decode(15, get_header_by_height_binary()) ==
             get_header_by_height_object()

    # header_hashes response
    assert PeerConnection.rlp_encode(100, header_hashes_response_object()) ==
             header_hashes_response_binary()

    assert PeerConnection.rlp_decode(100, header_hashes_response_binary()) ==
             header_hashes_response_decoded()

    # header response
    assert PeerConnection.rlp_encode(100, header_response_object()) == header_response_binary()

    assert PeerConnection.rlp_decode(100, header_response_binary()) == %{
             header_response_object()
             | object: %{header: header_response_object().object}
           }

    # block response
    assert PeerConnection.rlp_encode(100, block_response_object()) == block_response_binary()

    assert PeerConnection.rlp_decode(100, block_response_binary()) == %{
             block_response_object()
             | object: %{block: block_response_object().object}
           }

    # mempool response
    assert PeerConnection.rlp_encode(100, mempool_response_object()) == mempool_response_binary()

    assert PeerConnection.rlp_decode(100, mempool_response_binary()) == mempool_response_object()
  end

  def ping_object do
    %{
      best_hash:
        <<254, 17, 240, 34, 119, 165, 230, 98, 79, 102, 52, 13, 100, 213, 41, 139, 25, 111, 250,
          78, 94, 33, 20, 202, 237, 162, 77, 160, 205, 159, 30, 146>>,
      difficulty: 190.0362341,
      genesis_hash:
        <<254, 17, 240, 34, 119, 165, 230, 98, 79, 102, 52, 13, 100, 213, 41, 139, 25, 111, 250,
          78, 94, 33, 20, 202, 237, 162, 77, 160, 205, 159, 30, 146>>,
      peers: [
        %{
          host: '31.13.249.70',
          port: 3015,
          pubkey:
            <<225, 20, 115, 180, 23, 84, 149, 52, 111, 153, 254, 213, 39, 210, 49, 196, 30, 21, 9,
              93, 48, 103, 84, 63, 207, 94, 95, 41, 134, 145, 215, 123>>
        }
      ],
      port: 3015,
      share: 32
    }
  end

  def ping_binary do
    <<248, 150, 1, 130, 11, 199, 32, 160, 254, 17, 240, 34, 119, 165, 230, 98, 79, 102, 52, 13,
      100, 213, 41, 139, 25, 111, 250, 78, 94, 33, 20, 202, 237, 162, 77, 160, 205, 159, 30, 146,
      154, 49, 46, 57, 48, 48, 51, 54, 50, 51, 52, 49, 48, 48, 48, 48, 48, 48, 48, 49, 52, 57, 48,
      101, 43, 48, 50, 160, 254, 17, 240, 34, 119, 165, 230, 98, 79, 102, 52, 13, 100, 213, 41,
      139, 25, 111, 250, 78, 94, 33, 20, 202, 237, 162, 77, 160, 205, 159, 30, 146, 243, 178, 241,
      140, 51, 49, 46, 49, 51, 46, 50, 52, 57, 46, 55, 48, 130, 11, 199, 160, 225, 20, 115, 180,
      23, 84, 149, 52, 111, 153, 254, 213, 39, 210, 49, 196, 30, 21, 9, 93, 48, 103, 84, 63, 207,
      94, 95, 41, 134, 145, 215, 123>>
  end

  def get_block_and_header_by_hash_object do
    %{
      hash:
        <<138, 11, 233, 125, 181, 144, 59, 74, 102, 52, 231, 228, 25, 248, 145, 174, 249, 194,
          130, 12, 231, 24, 149, 234, 95, 143, 94, 11, 124, 6, 118, 78>>
    }
  end

  def get_block_and_header_by_hash_binary do
    <<226, 1, 160, 138, 11, 233, 125, 181, 144, 59, 74, 102, 52, 231, 228, 25, 248, 145, 174, 249,
      194, 130, 12, 231, 24, 149, 234, 95, 143, 94, 11, 124, 6, 118, 78>>
  end

  def get_header_by_height_object do
    %{height: 5}
  end

  def get_header_by_height_binary do
    <<194, 1, 5>>
  end

  def get_n_successors_object do
    %{
      hash:
        <<138, 11, 233, 125, 181, 144, 59, 74, 102, 52, 231, 228, 25, 248, 145, 174, 249, 194,
          130, 12, 231, 24, 149, 234, 95, 143, 94, 11, 124, 6, 118, 78>>,
      n: 5
    }
  end

  def get_n_successors_binary do
    <<227, 1, 160, 138, 11, 233, 125, 181, 144, 59, 74, 102, 52, 231, 228, 25, 248, 145, 174, 249,
      194, 130, 12, 231, 24, 149, 234, 95, 143, 94, 11, 124, 6, 118, 78, 5>>
  end

  def header_hashes_response_object do
    %{
      object: [
        <<138, 11, 233, 125, 181, 144, 59, 74, 102, 52, 231, 228, 25, 248, 145, 174, 249, 194,
          130, 12, 231, 24, 149, 234, 95, 143, 94, 11, 124, 6, 118, 78>>
      ],
      reason: nil,
      result: true,
      type: 6
    }
  end

  def header_hashes_response_binary do
    <<233, 1, 1, 6, 128, 164, 227, 1, 225, 160, 138, 11, 233, 125, 181, 144, 59, 74, 102, 52, 231,
      228, 25, 248, 145, 174, 249, 194, 130, 12, 231, 24, 149, 234, 95, 143, 94, 11, 124, 6, 118,
      78>>
  end

  def header_hashes_response_decoded do
    %{
      object: %{
        hashes: [
          %{
            hash:
              <<102, 52, 231, 228, 25, 248, 145, 174, 249, 194, 130, 12, 231, 24, 149, 234, 95,
                143, 94, 11, 124, 6, 118, 78>>,
            height: 9_947_300_928_104_184_650
          }
        ]
      },
      reason: nil,
      result: true,
      type: 6
    }
  end

  def header_response_object do
    %{
      object: %Aecore.Chain.Header{
        height: 1,
        miner:
          <<210, 141, 234, 157, 137, 76, 97, 233, 212, 52, 214, 131, 152, 227, 196, 184, 128, 197,
            67, 203, 137, 28, 43, 186, 141, 106, 213, 142, 92, 236, 163, 189>>,
        nonce: 108,
        pow_evidence: [
          788,
          1095,
          1794,
          2757,
          4568,
          4905,
          6003,
          7402,
          9117,
          9198,
          10_256,
          10_915,
          12_098,
          12_437,
          13_756,
          14_052,
          14_105,
          14_363,
          14_371,
          15_738,
          16_218,
          17_148,
          17_226,
          18_384,
          18_952,
          19_515,
          21_125,
          21_808,
          21_892,
          22_745,
          23_096,
          24_367,
          25_158,
          26_552,
          26_603,
          27_609,
          28_833,
          29_854,
          30_360,
          30_514,
          32_229,
          32_702
        ],
        prev_hash:
          <<21, 156, 171, 146, 198, 198, 172, 36, 173, 41, 235, 64, 240, 130, 201, 45, 239, 9,
            239, 128, 104, 104, 27, 44, 209, 61, 193, 163, 120, 145, 215, 212>>,
        root_hash:
          <<124, 142, 159, 127, 228, 51, 73, 171, 249, 34, 10, 142, 182, 0, 157, 0, 221, 130, 227,
            163, 74, 63, 255, 34, 170, 19, 130, 13, 33, 66, 47, 130>>,
        target: 553_713_663,
        time: 1_533_624_177_119,
        txs_hash:
          <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0>>,
        version: 14
      },
      reason: nil,
      result: true,
      type: 4
    }
  end

  def header_response_binary do
    <<249, 1, 94, 1, 1, 4, 128, 185, 1, 87, 249, 1, 84, 1, 185, 1, 80, 0, 0, 0, 0, 0, 0, 0, 14, 0,
      0, 0, 0, 0, 0, 0, 1, 21, 156, 171, 146, 198, 198, 172, 36, 173, 41, 235, 64, 240, 130, 201,
      45, 239, 9, 239, 128, 104, 104, 27, 44, 209, 61, 193, 163, 120, 145, 215, 212, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124,
      142, 159, 127, 228, 51, 73, 171, 249, 34, 10, 142, 182, 0, 157, 0, 221, 130, 227, 163, 74,
      63, 255, 34, 170, 19, 130, 13, 33, 66, 47, 130, 0, 0, 0, 0, 33, 0, 255, 255, 0, 0, 3, 20, 0,
      0, 4, 71, 0, 0, 7, 2, 0, 0, 10, 197, 0, 0, 17, 216, 0, 0, 19, 41, 0, 0, 23, 115, 0, 0, 28,
      234, 0, 0, 35, 157, 0, 0, 35, 238, 0, 0, 40, 16, 0, 0, 42, 163, 0, 0, 47, 66, 0, 0, 48, 149,
      0, 0, 53, 188, 0, 0, 54, 228, 0, 0, 55, 25, 0, 0, 56, 27, 0, 0, 56, 35, 0, 0, 61, 122, 0, 0,
      63, 90, 0, 0, 66, 252, 0, 0, 67, 74, 0, 0, 71, 208, 0, 0, 74, 8, 0, 0, 76, 59, 0, 0, 82,
      133, 0, 0, 85, 48, 0, 0, 85, 132, 0, 0, 88, 217, 0, 0, 90, 56, 0, 0, 95, 47, 0, 0, 98, 70,
      0, 0, 103, 184, 0, 0, 103, 235, 0, 0, 107, 217, 0, 0, 112, 161, 0, 0, 116, 158, 0, 0, 118,
      152, 0, 0, 119, 50, 0, 0, 125, 229, 0, 0, 127, 190, 0, 0, 0, 0, 0, 0, 0, 108, 0, 0, 1, 101,
      19, 31, 209, 223, 210, 141, 234, 157, 137, 76, 97, 233, 212, 52, 214, 131, 152, 227, 196,
      184, 128, 197, 67, 203, 137, 28, 43, 186, 141, 106, 213, 142, 92, 236, 163, 189>>
  end

  def block_response_object do
    %{
      object: %Aecore.Chain.Block{
        header: %Aecore.Chain.Header{
          height: 1,
          miner:
            <<210, 141, 234, 157, 137, 76, 97, 233, 212, 52, 214, 131, 152, 227, 196, 184, 128,
              197, 67, 203, 137, 28, 43, 186, 141, 106, 213, 142, 92, 236, 163, 189>>,
          nonce: 108,
          pow_evidence: [
            788,
            1095,
            1794,
            2757,
            4568,
            4905,
            6003,
            7402,
            9117,
            9198,
            10_256,
            10_915,
            12_098,
            12_437,
            13_756,
            14_052,
            14_105,
            14_363,
            14_371,
            15_738,
            16_218,
            17_148,
            17_226,
            18_384,
            18_952,
            19_515,
            21_125,
            21_808,
            21_892,
            22_745,
            23_096,
            24_367,
            25_158,
            26_552,
            26_603,
            27_609,
            28_833,
            29_854,
            30_360,
            30_514,
            32_229,
            32_702
          ],
          prev_hash:
            <<21, 156, 171, 146, 198, 198, 172, 36, 173, 41, 235, 64, 240, 130, 201, 45, 239, 9,
              239, 128, 104, 104, 27, 44, 209, 61, 193, 163, 120, 145, 215, 212>>,
          root_hash:
            <<124, 142, 159, 127, 228, 51, 73, 171, 249, 34, 10, 142, 182, 0, 157, 0, 221, 130,
              227, 163, 74, 63, 255, 34, 170, 19, 130, 13, 33, 66, 47, 130>>,
          target: 553_713_663,
          time: 1_533_624_177_119,
          txs_hash:
            <<0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
              0, 0, 0, 0>>,
          version: 14
        },
        txs: []
      },
      reason: nil,
      result: true,
      type: 11
    }
  end

  def block_response_binary do
    <<249, 1, 103, 1, 1, 11, 128, 185, 1, 96, 249, 1, 93, 1, 185, 1, 89, 249, 1, 86, 100, 14, 185,
      1, 80, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 1, 21, 156, 171, 146, 198, 198, 172,
      36, 173, 41, 235, 64, 240, 130, 201, 45, 239, 9, 239, 128, 104, 104, 27, 44, 209, 61, 193,
      163, 120, 145, 215, 212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 142, 159, 127, 228, 51, 73, 171, 249, 34, 10, 142, 182,
      0, 157, 0, 221, 130, 227, 163, 74, 63, 255, 34, 170, 19, 130, 13, 33, 66, 47, 130, 0, 0, 0,
      0, 33, 0, 255, 255, 0, 0, 3, 20, 0, 0, 4, 71, 0, 0, 7, 2, 0, 0, 10, 197, 0, 0, 17, 216, 0,
      0, 19, 41, 0, 0, 23, 115, 0, 0, 28, 234, 0, 0, 35, 157, 0, 0, 35, 238, 0, 0, 40, 16, 0, 0,
      42, 163, 0, 0, 47, 66, 0, 0, 48, 149, 0, 0, 53, 188, 0, 0, 54, 228, 0, 0, 55, 25, 0, 0, 56,
      27, 0, 0, 56, 35, 0, 0, 61, 122, 0, 0, 63, 90, 0, 0, 66, 252, 0, 0, 67, 74, 0, 0, 71, 208,
      0, 0, 74, 8, 0, 0, 76, 59, 0, 0, 82, 133, 0, 0, 85, 48, 0, 0, 85, 132, 0, 0, 88, 217, 0, 0,
      90, 56, 0, 0, 95, 47, 0, 0, 98, 70, 0, 0, 103, 184, 0, 0, 103, 235, 0, 0, 107, 217, 0, 0,
      112, 161, 0, 0, 116, 158, 0, 0, 118, 152, 0, 0, 119, 50, 0, 0, 125, 229, 0, 0, 127, 190, 0,
      0, 0, 0, 0, 0, 0, 108, 0, 0, 1, 101, 19, 31, 209, 223, 210, 141, 234, 157, 137, 76, 97, 233,
      212, 52, 214, 131, 152, 227, 196, 184, 128, 197, 67, 203, 137, 28, 43, 186, 141, 106, 213,
      142, 92, 236, 163, 189, 192>>
  end

  def mempool_response_object do
    %{
      object: %{
        txs: [
          %Aecore.Tx.SignedTx{
            data: %Aecore.Tx.DataTx{
              fee: 12,
              nonce: 1,
              payload: %Aecore.Account.Tx.SpendTx{
                amount: 10,
                payload: "",
                receiver: %Identifier{
                  type: :account,
                  value:
                    <<183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228,
                      23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16>>
                },
                version: 1
              },
              senders: [
                %Identifier{
                  type: :account,
                  value:
                    <<183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228,
                      23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16>>
                }
              ],
              ttl: 0,
              type: Aecore.Account.Tx.SpendTx
            },
            signatures: [
              <<48, 69, 2, 33, 0, 238, 28, 94, 28, 181, 175, 246, 145, 211, 91, 189, 59, 56, 181,
                244, 75, 55, 105, 75, 172, 21, 66, 216, 191, 192, 228, 28, 103, 90, 9, 43, 89, 2,
                32, 79, 49, 84, 183, 41, 189, 18, 156, 43, 109, 137, 127, 116, 204, 95, 51, 17,
                110, 117, 195, 157, 131, 109, 105, 1, 144, 202, 212, 58, 167, 132, 158>>
            ]
          },
          %Aecore.Tx.SignedTx{
            data: %Aecore.Tx.DataTx{
              fee: 10,
              nonce: 1,
              payload: %Aecore.Account.Tx.SpendTx{
                amount: 10,
                payload: "",
                receiver: %Identifier{
                  type: :account,
                  value:
                    <<183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228,
                      23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16>>
                },
                version: 1
              },
              senders: [
                %Identifier{
                  type: :account,
                  value:
                    <<183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228,
                      23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16>>
                }
              ],
              ttl: 0,
              type: Aecore.Account.Tx.SpendTx
            },
            signatures: [
              <<48, 69, 2, 32, 73, 174, 169, 160, 11, 222, 171, 84, 119, 202, 5, 247, 199, 184,
                73, 192, 212, 96, 191, 179, 73, 70, 71, 24, 216, 236, 189, 15, 175, 3, 157, 146,
                2, 33, 0, 128, 105, 124, 219, 7, 173, 170, 46, 7, 172, 101, 254, 150, 26, 171,
                100, 111, 39, 228, 60, 249, 193, 135, 150, 72, 102, 237, 199, 76, 21, 214, 125>>
            ]
          },
          %Aecore.Tx.SignedTx{
            data: %Aecore.Tx.DataTx{
              fee: 11,
              nonce: 1,
              payload: %Aecore.Account.Tx.SpendTx{
                amount: 10,
                payload: "",
                receiver: %Identifier{
                  type: :account,
                  value:
                    <<183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228,
                      23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16>>
                },
                version: 1
              },
              senders: [
                %Identifier{
                  type: :account,
                  value:
                    <<183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228,
                      23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16>>
                }
              ],
              ttl: 0,
              type: Aecore.Account.Tx.SpendTx
            },
            signatures: [
              <<48, 69, 2, 32, 79, 191, 59, 15, 60, 27, 214, 3, 1, 89, 191, 153, 58, 82, 77, 213,
                122, 7, 53, 230, 196, 157, 187, 88, 135, 3, 122, 22, 104, 14, 91, 119, 2, 33, 0,
                148, 195, 72, 36, 5, 53, 241, 134, 161, 45, 65, 77, 200, 138, 136, 38, 92, 225,
                249, 76, 177, 10, 67, 18, 26, 113, 202, 108, 123, 138, 246, 184>>
            ]
          }
        ]
      },
      reason: nil,
      result: true,
      type: 14
    }
  end

  def mempool_response_binary do
    <<249, 1, 238, 1, 1, 14, 128, 185, 1, 231, 249, 1, 228, 1, 249, 1, 224, 184, 158, 248, 156,
      11, 1, 248, 73, 184, 71, 48, 69, 2, 33, 0, 238, 28, 94, 28, 181, 175, 246, 145, 211, 91,
      189, 59, 56, 181, 244, 75, 55, 105, 75, 172, 21, 66, 216, 191, 192, 228, 28, 103, 90, 9, 43,
      89, 2, 32, 79, 49, 84, 183, 41, 189, 18, 156, 43, 109, 137, 127, 116, 204, 95, 51, 17, 110,
      117, 195, 157, 131, 109, 105, 1, 144, 202, 212, 58, 167, 132, 158, 184, 77, 248, 75, 12, 1,
      161, 1, 183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228, 23, 4,
      75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16, 161, 1, 183, 82, 43, 247, 176, 2,
      118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228, 23, 4, 75, 105, 32, 60, 200, 63, 71, 223,
      83, 201, 235, 246, 16, 10, 12, 0, 1, 128, 184, 158, 248, 156, 11, 1, 248, 73, 184, 71, 48,
      69, 2, 32, 73, 174, 169, 160, 11, 222, 171, 84, 119, 202, 5, 247, 199, 184, 73, 192, 212,
      96, 191, 179, 73, 70, 71, 24, 216, 236, 189, 15, 175, 3, 157, 146, 2, 33, 0, 128, 105, 124,
      219, 7, 173, 170, 46, 7, 172, 101, 254, 150, 26, 171, 100, 111, 39, 228, 60, 249, 193, 135,
      150, 72, 102, 237, 199, 76, 21, 214, 125, 184, 77, 248, 75, 12, 1, 161, 1, 183, 82, 43, 247,
      176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228, 23, 4, 75, 105, 32, 60, 200, 63,
      71, 223, 83, 201, 235, 246, 16, 161, 1, 183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250,
      197, 31, 24, 159, 228, 23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16, 10,
      10, 0, 1, 128, 184, 158, 248, 156, 11, 1, 248, 73, 184, 71, 48, 69, 2, 32, 79, 191, 59, 15,
      60, 27, 214, 3, 1, 89, 191, 153, 58, 82, 77, 213, 122, 7, 53, 230, 196, 157, 187, 88, 135,
      3, 122, 22, 104, 14, 91, 119, 2, 33, 0, 148, 195, 72, 36, 5, 53, 241, 134, 161, 45, 65, 77,
      200, 138, 136, 38, 92, 225, 249, 76, 177, 10, 67, 18, 26, 113, 202, 108, 123, 138, 246, 184,
      184, 77, 248, 75, 12, 1, 161, 1, 183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197,
      31, 24, 159, 228, 23, 4, 75, 105, 32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16, 161, 1,
      183, 82, 43, 247, 176, 2, 118, 61, 57, 250, 89, 250, 197, 31, 24, 159, 228, 23, 4, 75, 105,
      32, 60, 200, 63, 71, 223, 83, 201, 235, 246, 16, 10, 11, 0, 1, 128>>
  end
end
