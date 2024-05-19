import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:trainit/data/data_provider/local_account_provider.dart';
import 'package:trainit/data/data_provider/remote_authentication_provider.dart';
import 'package:trainit/data/data_provider/remote_account_provider.dart';
import 'package:trainit/data/database.dart';
import 'package:trainit/data/files.dart';
import 'package:trainit/data/model/account.dart';
import 'package:trainit/data/model/calendar_training.dart';
import 'package:trainit/data/model/dto/read_account.dart';
import 'package:trainit/data/model/exercise.dart';
import 'package:trainit/data/model/personal_record.dart';
import 'package:trainit/data/model/personal_record_type.dart';
import 'package:trainit/data/model/training.dart';
import 'package:trainit/data/model/training_days.dart';
import 'package:trainit/data/model/training_plan.dart';
import 'package:trainit/data/model/training_set.dart';
import 'package:trainit/data/model/units.dart';
import 'package:trainit/data/repository/account_repository.dart';
import 'package:trainit/data/shared_preferences.dart';

import 'account_repository_test.mocks.dart';

@GenerateMocks([
  Client,
  RemoteAuthenticationProvider,
  LocalDatabase,
  LocalFiles,
  KeyValueStorage,
  File,
])
void main() {
  final expectedAccountDtoOne = ReadAccountDto(
    alreadyUpToDate: false,
    account: Account(
      id: "a28VMwRLc6Z89RENj3q3dQySEoJ3",
      username: "StativJovo",
      isPublicProfile: true,
      weightUnit: WeightUnit.kg,
      averageSetDuration: 90,
      averageSetRestDuration: 345,
      trainingPlanId: "682487e1-f8b2-4908-819c-ed012ab006fa",
      lastModified: DateTime.utc(2023, 8, 22, 14, 11, 29, 0),
    ),
    personalRecords: [
      PersonalRecord(
        date: DateTime.utc(2023, 8, 20, 8, 9, 6),
        name: "Bench Press",
        unit: Unit.kilograms,
        value: 200,
        isFavorite: false,
      ),
      PersonalRecord(
        date: DateTime.utc(2023, 8, 20, 8, 36, 27),
        name: "Box Jump",
        unit: Unit.meters,
        value: 1.55,
        isFavorite: false,
      ),
    ],
    calendarTrainings: [
      CalendarTraining(
          baseTrainingId: "10308475-635e-4697-a962-801893c577f6",
          id: "69d6d167-4a3b-47cd-a436-b9bb3539eaef",
          name: "Back + Biceps",
          supersetIndexes: [],
          exercises: [
            Exercise(
              id: "5f274dbe-7509-4f7f-aae1-85fffddd845b",
              name: "Rowing",
              sets: [
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 12),
              ],
            ),
            Exercise(
              id: "54a0594f-166c-422e-9cf6-b6ea0013be8d",
              name: "Lat Pulldown",
              sets: [
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 10),
                TrainingSet(repetitions: 10),
              ],
            ),
            Exercise(
              id: "aec821a9-9c24-4cb2-b508-d1c29d16cb7e",
              name: "Bent Over Flies",
              sets: [
                TrainingSet(repetitions: 10),
                TrainingSet(repetitions: 10),
                TrainingSet(repetitions: 10),
              ],
            ),
            Exercise(
              id: "6466c1ab-a634-4af4-bc47-5cd8b71489e5",
              name: "Barbell Curls",
              sets: [
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 12),
              ],
            ),
            Exercise(
              id: "ec8a7890-5f8e-40f7-a806-a0d90c25f4ce",
              name: "Hammer Curls",
              sets: [
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 12),
                TrainingSet(repetitions: 12),
              ],
            ),
          ],
          date: DateTime.utc(2023, 8, 23))
    ],
    trainingPlans: [
      TrainingPlan(
        id: "682487e1-f8b2-4908-819c-ed012ab006fa",
        name: "3 Day Split",
        createdOn: DateTime.utc(2023, 2, 16),
        accountId: "a28VMwRLc6Z89RENj3q3dQySEoJ3",
        days: TrainingDays(
          friday: [],
          monday: [
            Training(
              id: "2371ef8d-b9c4-41c5-8c15-1d610925228c",
              name: "Chest + Triceps + Shoulders",
              supersetIndexes: [],
              exercises: [
                Exercise(
                  id: "990fd2bb-8156-4125-ad6d-83587ffbdbf4",
                  name: "Bench Press",
                  sets: [
                    TrainingSet(repetitions: 8),
                    TrainingSet(repetitions: 8),
                    TrainingSet(repetitions: 6),
                  ],
                ),
                Exercise(
                  id: "f52854d5-a446-49da-ad15-54b32f8c8ea7",
                  name: "Incline Dumbell Press",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 8),
                  ],
                ),
                Exercise(
                  id: "7f86bec8-9571-4f0a-9c3f-160805404dd6",
                  name: "Lateral Raises",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                  ],
                ),
                Exercise(
                  id: "d046f288-bbf3-40a3-8f19-b430ef32b209",
                  name: "Skullcrushers",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 8),
                  ],
                ),
                Exercise(
                  id: "36cf9cef-65f9-4846-92ee-3bc982875e79",
                  name: "Rope Pressdown",
                  sets: [
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                  ],
                ),
              ],
            )
          ],
          sunday: [],
          tuesday: [],
          saturday: [],
          thursday: [
            Training(
              id: "360bd5ce-49f7-4a2c-b64f-530ae3692254",
              name: "Legs",
              supersetIndexes: [],
              exercises: [
                Exercise(
                  id: "b7d8c171-51b5-42d7-bad3-e924f7c771a2",
                  name: "Squat",
                  sets: [
                    TrainingSet(repetitions: 8),
                    TrainingSet(repetitions: 8),
                    TrainingSet(repetitions: 8),
                  ],
                ),
                Exercise(
                  id: "66dcf6f5-e2a1-4666-b24b-2834289800a5",
                  name: "Leg Press",
                  sets: [
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                  ],
                ),
                Exercise(
                  id: "04ce8f86-ec7d-49aa-b880-8b7db01f2063",
                  name: "Leg Extension",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 8),
                  ],
                ),
                Exercise(
                  id: "6c2cacd0-1dca-4dfc-9b5c-a0cd14d2f994",
                  name: "Calf Raises",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                  ],
                ),
              ],
            )
          ],
          wednesday: [
            Training(
              id: "10308475-635e-4697-a962-801893c577f6",
              name: "Back + Biceps",
              supersetIndexes: [],
              exercises: [
                Exercise(
                  id: "5f274dbe-7509-4f7f-aae1-85fffddd845b",
                  name: "Rowing",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                  ],
                ),
                Exercise(
                  id: "54a0594f-166c-422e-9cf6-b6ea0013be8d",
                  name: "Lat Pulldown",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                  ],
                ),
                Exercise(
                  id: "aec821a9-9c24-4cb2-b508-d1c29d16cb7e",
                  name: "Bent Over Flies",
                  sets: [
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                    TrainingSet(repetitions: 10),
                  ],
                ),
                Exercise(
                  id: "6466c1ab-a634-4af4-bc47-5cd8b71489e5",
                  name: "Barbell Curls",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                  ],
                ),
                Exercise(
                  id: "ec8a7890-5f8e-40f7-a806-a0d90c25f4ce",
                  name: "Hammer Curls",
                  sets: [
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                    TrainingSet(repetitions: 12),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  const exampleGetAccountResponseOne =
      '{"account":{"id":"a28VMwRLc6Z89RENj3q3dQySEoJ3","username":"StativJovo","isPublicProfile":true,"weightUnit":"kg","averageSetDuration":90,"averageSetRestDuration":345,"trainingPlanId":"682487e1-f8b2-4908-819c-ed012ab006fa","personalRecords":[{"date":"2023-08-20T10:09:06","name":"Bench Press","unit":"kg","value":200,"isFavorite":false},{"date":"2023-08-20T10:36:27","name":"Box Jump","unit":"m","value":1.55,"isFavorite":false}],"calendarTrainings":[{"id":"69d6d167-4a3b-47cd-a436-b9bb3539eaef","date":"2023-08-23","name":"Back + Biceps","partners":[],"exercises":[{"id":"5f274dbe-7509-4f7f-aae1-85fffddd845b","name":"Rowing","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"54a0594f-166c-422e-9cf6-b6ea0013be8d","name":"Lat Pulldown","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":10}]},{"id":"aec821a9-9c24-4cb2-b508-d1c29d16cb7e","name":"Bent Over Flies","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"6466c1ab-a634-4af4-bc47-5cd8b71489e5","name":"Barbell Curls","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"ec8a7890-5f8e-40f7-a806-a0d90c25f4ce","name":"Hammer Curls","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]}],"baseTrainingId":"10308475-635e-4697-a962-801893c577f6"}],"lastModified":"2023-08-22T14:11:29.000Z"},"trainingPlans":[{"id":"682487e1-f8b2-4908-819c-ed012ab006fa","name":"3 Day Split","days":{"friday":[],"monday":[{"id":"2371ef8d-b9c4-41c5-8c15-1d610925228c","name":"Chest + Triceps + Shoulders","exercises":[{"id":"990fd2bb-8156-4125-ad6d-83587ffbdbf4","name":"Bench Press","sets":[{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"f52854d5-a446-49da-ad15-54b32f8c8ea7","name":"Incline Dumbell Press","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"7f86bec8-9571-4f0a-9c3f-160805404dd6","name":"Lateral Raises","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"d046f288-bbf3-40a3-8f19-b430ef32b209","name":"Skullcrushers","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"36cf9cef-65f9-4846-92ee-3bc982875e79","name":"Rope Pressdown","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]}]}],"sunday":[],"tuesday":[],"saturday":[],"thursday":[{"id":"360bd5ce-49f7-4a2c-b64f-530ae3692254","name":"Legs","exercises":[{"id":"b7d8c171-51b5-42d7-bad3-e924f7c771a2","name":"Squat","sets":[{"repetitions":8},{"repetitions":8},{"repetitions":8}]},{"id":"66dcf6f5-e2a1-4666-b24b-2834289800a5","name":"Leg Press","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"04ce8f86-ec7d-49aa-b880-8b7db01f2063","name":"Leg Extension","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"6c2cacd0-1dca-4dfc-9b5c-a0cd14d2f994","name":"Calf Raises","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]}]}],"wednesday":[{"id":"10308475-635e-4697-a962-801893c577f6","name":"Back + Biceps","exercises":[{"id":"5f274dbe-7509-4f7f-aae1-85fffddd845b","name":"Rowing","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"54a0594f-166c-422e-9cf6-b6ea0013be8d","name":"Lat Pulldown","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":10}]},{"id":"aec821a9-9c24-4cb2-b508-d1c29d16cb7e","name":"Bent Over Flies","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"6466c1ab-a634-4af4-bc47-5cd8b71489e5","name":"Barbell Curls","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"ec8a7890-5f8e-40f7-a806-a0d90c25f4ce","name":"Hammer Curls","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]}]}]},"createdOn":"2023-02-16T00:00:00.000Z","accountId":"a28VMwRLc6Z89RENj3q3dQySEoJ3"}],"alreadyUpToDate":false}';

  final client = MockClient();
  final database = MockLocalDatabase();
  final files = MockLocalFiles();
  final keyValueStorage = MockKeyValueStorage();
  final localProvider = LocalAccountProvider(
    keyValueStorage: keyValueStorage,
    database: database,
    files: files,
  );
  final remoteProvider = RemoteAccountProvider(client: client);
  final authProvider = MockRemoteAuthenticationProvider();

  final repo = AccountRepository(
    authProvider: authProvider,
    remoteProvider: remoteProvider,
    localProvider: localProvider,
  );

  when(
    authProvider.userId,
  ).thenAnswer((_) => "userId");
  when(
    authProvider.getUserToken(),
  ).thenAnswer((_) async => "authToken");
  when(
    authProvider.isSignedIn,
  ).thenAnswer((_) => true);

  group('Read Account', () {
    test("Read account", () async {
      when(
        client.get(
          Uri.parse("https://10.0.2.2:8080/user/userId?savedState=null"),
          headers: {"Authorization": "Bearer authToken"},
        ),
      ).thenAnswer((_) async => Response(exampleGetAccountResponseOne, 200));
      final result = await repo.readAllRemote(null);
      expect(
        jsonEncode(result.account),
        jsonEncode(expectedAccountDtoOne.account),
      );
      expect(
        jsonEncode(result.trainingPlans),
        jsonEncode(expectedAccountDtoOne.trainingPlans),
      );
      expect(
        jsonEncode(result.calendarTrainings),
        jsonEncode(expectedAccountDtoOne.calendarTrainings),
      );
      expect(
        jsonEncode(result.personalRecords),
        jsonEncode(expectedAccountDtoOne.personalRecords),
      );
    });
  });

  group('Create Account', () {
    test("Create Account with valid response", () async {
      when(
        client.post(
          Uri.parse("https://10.0.2.2:8080/user?username=ExampleUsername"),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
          encoding: anyNamed('encoding'),
        ),
      ).thenAnswer((_) async => Response("success", 200));
      final result = await repo.createAccount("ExampleUsername");
      expect(result, true);
    });

    test("Create Account with already existing name", () async {
      when(
        client.post(
          Uri.parse("https://10.0.2.2:8080/user?username=ExampleUsername"),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
          encoding: anyNamed('encoding'),
        ),
      ).thenAnswer((_) async => Response("already existing", 409));

      final result = await repo.createAccount("ExampleUsername");
      expect(result, false);
    });
  });

  group('Download Profile Photo', () {
    final profilePhotoData = Uint8List(4);
    final profilePhotoFile = MockFile();

    test("Download Profile Photo", () async {
      when(
        client.get(
          Uri.parse("https://10.0.2.2:8080/user/userId/photo.webp"),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
          (_) async => Response(String.fromCharCodes(profilePhotoData), 200));
      when(
        files.getProfilePhotoFile(),
      ).thenAnswer((_) async => profilePhotoFile);
      when(
        profilePhotoFile.create(),
      ).thenAnswer((_) async => profilePhotoFile);
      when(
        profilePhotoFile.writeAsBytes(any),
      ).thenAnswer((_) async => profilePhotoFile);

      final result = await repo.downloadProfilePhoto();
      expect(result, true);
    });

    test("Download not existing profile photo", () async {
      when(
        client.get(
          Uri.parse("https://10.0.2.2:8080/user/userId/photo.webp"),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => Response("", 404));
      when(
        files.getProfilePhotoFile(),
      ).thenAnswer((_) async => profilePhotoFile);
      when(
        profilePhotoFile.create(),
      ).thenAnswer((_) async => profilePhotoFile);
      when(
        profilePhotoFile.writeAsBytes(any),
      ).thenAnswer((e) async => throw "Write as Bytes should not be called");

      final result = await repo.downloadProfilePhoto();
      expect(result, true);
    });
  });

  group('Download Profile Photo', () {
    final profilePhotoData = Uint8List(4);
    final profilePhotoFile = MockFile();

    test("Download Profile Photo", () async {
      when(
        client.get(
          Uri.parse("https://10.0.2.2:8080/user/userId/photo.webp"),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
          (_) async => Response(String.fromCharCodes(profilePhotoData), 200));
      when(
        files.getProfilePhotoFile(),
      ).thenAnswer((_) async => profilePhotoFile);
      when(
        profilePhotoFile.create(),
      ).thenAnswer((_) async => profilePhotoFile);
      when(
        profilePhotoFile.writeAsBytes(any),
      ).thenAnswer((_) async => profilePhotoFile);

      final result = await repo.downloadProfilePhoto();
      expect(result, true);
    });
  });
}
