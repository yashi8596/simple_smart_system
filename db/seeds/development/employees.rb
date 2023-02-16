last_names = %w{
  佐藤:サトウ:sato
  山本:ヤマモト:yamamoto
  上村:ウエムラ:uemura
  前川:マエカワ:maekawa
}

first_names = %w{
  翔太:ショウタ:shouta
  一:ハジメ:hajime
  遥:ハルカ:haruka
  夏帆:カホ:kaho
  恵梨香:エリカ:erika
}

addresses = %w{
  愛知:ABC:&&&:1-2
  岐阜:DEF:###:3-5
  長野:GHI:$$$:1-4
  静岡:JKL:!!!:2-1
  三重:MNO:???:2-2
  富山:PQR:+++:4-5
  石川:STU:===:3-2
  福井:VWX:@@@:4-1
}

20.times do |n|
  ln = last_names[n % 4].split(":")
  fn = first_names[n % 5].split(":")
  ad = addresses[n % 8].split(":")
  tn = 8.times.map { rand(9) }.join

  Employee.create!(
    {
      employee_number: 7.times.map { rand(8) }.join.to_s,
      last_name: ln[0],
      first_name: fn[0],
      last_name_kana: ln[1],
      first_name_kana: fn[1],
      password: "password",
      address: "#{ad[0]}県#{ad[1]}市#{ad[2]}町#{ad[3]}",
      telephone_number: "012#{tn}",
      email: "#{ln[2]}.#{fn[2]}@exam.com",
      start_date: (181 - n).days.ago.to_date,
      end_date: n == 7 ?  Date.today : nil,
      suspended: n == 4,
      next_grant_date: n <= 1 ?  (181 - n).days.ago.to_date.since(18.month) : (181 - n).days.ago.to_date.since(6.month),
      prev_grant_date: n <= 1 ?  (181 - n).days.ago.to_date.since(6.month) : nil,
      number_of_paid_leave: n <= 1 ?  10 : 0,
      granted: n <= 1 ?  true : false,
    }
  )
end