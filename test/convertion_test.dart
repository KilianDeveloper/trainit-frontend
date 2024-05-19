import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trainit/data/model/dto/read_account.dart';

const String jsonResult =
    '{"account":{"id":"a28VMwRLc6Z89RENj3q3dQySEoJ3","username":"legojovo@gmx.de","isPublicProfile":true,"weightUnit":"kg","averageSetDuration":90,"averageSetRestDuration":90,"trainingPlanId":"0420cc12-1ac8-4142-a1bb-009531922e9b","personalRecords":[],"calendarTrainings":[{"id":"fff761f9-8bf3-4cce-ae92-b102a8c72f3e","date":"2023-3-20","name":"Brust + Bizeps + Trizeps","partners":[],"exercises":[{"id":"4bdfbbfc-967c-43fb-9e72-415048165260","name":"Langhantel Schrägbankdrücken","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8},{"repetitions":6}]},{"id":"051d75a5-f35d-4f82-977e-b024ca7c5acd","name":"Kurzhantel Flachbankdrücken","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"d00c19cf-66f1-47ba-bb27-5f3e1456a66a","name":"Fliegende Schrägbank","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"47643556-42c9-4cea-adf8-8b7dccd56190","name":"Dips","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"07542934-a36c-4056-9bc8-755d21ca002c","name":"Langhantel Curls","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"ca2bf6e1-131c-433e-8434-a8693ef2a96d","name":"Scott Curls SZ","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"2681c8b6-0f29-494e-8e0c-b1e284163950","name":"Hammer Curls Kurzhantel sitzend","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"d2e6ccb7-c877-4908-a9bf-cb7cf70fec3f","name":"French Press","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"c1016444-e566-4df8-96ac-5deeac14f91d","name":"Trizepsdrücken Kurzhantel","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"c5b45e4b-400e-45bd-bc66-7fecf2a9c8e0","name":"Trizepsdrücken Kabel Untergriff","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6}]}],"baseTrainingId":"5e1ed776-7673-4f28-9527-9d681389ab13"},{"id":"27e174f1-136b-42bd-9265-299eaf231776","date":"2023-3-22","name":"Rücken + Schulter + Bauch ","partners":[],"exercises":[{"id":"82dc3b87-0f66-42bb-8887-57dd5d19b600","name":"Latziehen Breit","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"f4b3a531-3089-46be-95c2-246517307d50","name":"Latziehen Eng","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"ccac6649-8e49-49bf-94dc-ce9f4717c5ff","name":"Rudern sitzend Kabel","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6}]},{"id":"4d2121fd-8629-487f-bc22-b865260fadb6","name":"Rudern Langhantel Untergriff","sets":[{"repetitions":8},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"eb9e1553-80ed-498f-a1fd-6de100904792","name":"Nackenheben Langhantel ","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"baffdb8a-3cf9-49ea-85a5-b4189758a485","name":"Nackendrücken Langhantel","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"26f8cb24-e930-4675-ba49-c539e1538e42","name":"Seitheben Kurzhantel","sets":[{"repetitions":15},{"repetitions":15},{"repetitions":10}]},{"id":"379fc5a7-6ba1-40f9-bda3-b531c27d3e9f","name":"Seitheben vorgebeugt Kurzhantel","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"34b93d8c-9400-4798-8f49-e1c31d79cb1e","name":"Dips","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6}]},{"id":"8f832fb1-5b83-402f-ba73-e33bcb243d0e","name":"Beinheben","sets":[{"repetitions":20},{"repetitions":20},{"repetitions":20}]},{"id":"ff41bb13-3abd-40b5-8a00-054546916a21","name":"Crunch kniend Kabel","sets":[{"repetitions":20}]}],"baseTrainingId":"17579338-ced5-4cd9-b070-1cc54d549bdd"},{"id":"deadea21-8148-4eb9-b123-19fa370daa9e","date":"2023-3-17","name":"Beine","partners":[],"exercises":[{"id":"0f220fd0-2bf1-4c0d-ba65-9dc6f44c9c91","name":"Beinstrecken","sets":[{"repetitions":20},{"repetitions":15},{"repetitions":12}]},{"id":"26512ea9-dd54-454f-9c93-c5c0d45fe951","name":"Kniebeugen","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6},{"repetitions":4}]},{"id":"0ac0d164-9a20-459b-ba44-d503d6944b34","name":"Beinpresse","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"5b02afd2-21cd-45aa-ae6b-968e82c80a79","name":"Beincurls liegend","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"e4e51015-4ca1-48a4-83bd-f1fcde9939e1","name":"Wadenheben stehend","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10}]},{"id":"106702e5-18b2-4bcf-80d3-49461c5514fd","name":"Wadenheben sitzend","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10}]}],"baseTrainingId":"9a9aefbc-ba37-4cdc-ba86-fe6841707102"}],"lastModified":"2023-03-16T16:09:05.000Z"},"trainingPlans":[{"id":"0420cc12-1ac8-4142-a1bb-009531922e9b","name":"Your Training Plan","days":{"friday":[{"id":"9a9aefbc-ba37-4cdc-ba86-fe6841707102","name":"Beine","exercises":[{"id":"0f220fd0-2bf1-4c0d-ba65-9dc6f44c9c91","name":"Beinstrecken","sets":[{"repetitions":20},{"repetitions":15},{"repetitions":12}]},{"id":"26512ea9-dd54-454f-9c93-c5c0d45fe951","name":"Kniebeugen","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6},{"repetitions":4}]},{"id":"0ac0d164-9a20-459b-ba44-d503d6944b34","name":"Beinpresse","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"5b02afd2-21cd-45aa-ae6b-968e82c80a79","name":"Beincurls liegend","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"e4e51015-4ca1-48a4-83bd-f1fcde9939e1","name":"Wadenheben stehend","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10}]},{"id":"106702e5-18b2-4bcf-80d3-49461c5514fd","name":"Wadenheben sitzend","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10}]}]}],"monday":[{"id":"5e1ed776-7673-4f28-9527-9d681389ab13","name":"Brust + Bizeps + Trizeps","exercises":[{"id":"4bdfbbfc-967c-43fb-9e72-415048165260","name":"Langhantel Schrägbankdrücken","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8},{"repetitions":6}]},{"id":"051d75a5-f35d-4f82-977e-b024ca7c5acd","name":"Kurzhantel Flachbankdrücken","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"d00c19cf-66f1-47ba-bb27-5f3e1456a66a","name":"Fliegende Schrägbank","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"47643556-42c9-4cea-adf8-8b7dccd56190","name":"Dips","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"07542934-a36c-4056-9bc8-755d21ca002c","name":"Langhantel Curls","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"ca2bf6e1-131c-433e-8434-a8693ef2a96d","name":"Scott Curls SZ","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"2681c8b6-0f29-494e-8e0c-b1e284163950","name":"Hammer Curls Kurzhantel sitzend","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"d2e6ccb7-c877-4908-a9bf-cb7cf70fec3f","name":"French Press","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"c1016444-e566-4df8-96ac-5deeac14f91d","name":"Trizepsdrücken Kurzhantel","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"c5b45e4b-400e-45bd-bc66-7fecf2a9c8e0","name":"Trizepsdrücken Kabel Untergriff","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6}]}]}],"sunday":[],"tuesday":[],"saturday":[],"thursday":[],"wednesday":[{"id":"17579338-ced5-4cd9-b070-1cc54d549bdd","name":"Rücken + Schulter + Bauch ","exercises":[{"id":"82dc3b87-0f66-42bb-8887-57dd5d19b600","name":"Latziehen Breit","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"f4b3a531-3089-46be-95c2-246517307d50","name":"Latziehen Eng","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"ccac6649-8e49-49bf-94dc-ce9f4717c5ff","name":"Rudern sitzend Kabel","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6}]},{"id":"4d2121fd-8629-487f-bc22-b865260fadb6","name":"Rudern Langhantel Untergriff","sets":[{"repetitions":8},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"eb9e1553-80ed-498f-a1fd-6de100904792","name":"Nackenheben Langhantel ","sets":[{"repetitions":15},{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"baffdb8a-3cf9-49ea-85a5-b4189758a485","name":"Nackendrücken Langhantel","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"26f8cb24-e930-4675-ba49-c539e1538e42","name":"Seitheben Kurzhantel","sets":[{"repetitions":15},{"repetitions":15},{"repetitions":10}]},{"id":"379fc5a7-6ba1-40f9-bda3-b531c27d3e9f","name":"Seitheben vorgebeugt Kurzhantel","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"34b93d8c-9400-4798-8f49-e1c31d79cb1e","name":"Dips","sets":[{"repetitions":10},{"repetitions":8},{"repetitions":6}]},{"id":"8f832fb1-5b83-402f-ba73-e33bcb243d0e","name":"Beinheben","sets":[{"repetitions":20},{"repetitions":20},{"repetitions":20}]},{"id":"ff41bb13-3abd-40b5-8a00-054546916a21","name":"Crunch kniend Kabel","sets":[{"repetitions":20}]}]}]},"createdOn":"2023-03-01T00:00:00.000Z","accountId":"a28VMwRLc6Z89RENj3q3dQySEoJ3"},{"id":"682487e1-f8b2-4908-819c-ed012ab006fa","name":"3 Day Split 1","days":{"friday":[],"monday":[{"id":"2371ef8d-b9c4-41c5-8c15-1d610925228c","name":"Chest + Triceps + Shoulders","exercises":[{"id":"990fd2bb-8156-4125-ad6d-83587ffbdbf4","name":"Bench Press","sets":[{"repetitions":8},{"repetitions":8},{"repetitions":6}]},{"id":"f52854d5-a446-49da-ad15-54b32f8c8ea7","name":"Incline Dumbell Press","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"7f86bec8-9571-4f0a-9c3f-160805404dd6","name":"Lateral Raises","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"d046f288-bbf3-40a3-8f19-b430ef32b209","name":"Skullcrushers","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"36cf9cef-65f9-4846-92ee-3bc982875e79","name":"Rope Pressdown","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]}]}],"sunday":[],"tuesday":[],"saturday":[],"thursday":[{"id":"360bd5ce-49f7-4a2c-b64f-530ae3692254","name":"Legs","exercises":[{"id":"b7d8c171-51b5-42d7-bad3-e924f7c771a2","name":"Squat","sets":[{"repetitions":8},{"repetitions":8},{"repetitions":8}]},{"id":"66dcf6f5-e2a1-4666-b24b-2834289800a5","name":"Leg Press","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"04ce8f86-ec7d-49aa-b880-8b7db01f2063","name":"Leg Extension","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":8}]},{"id":"6c2cacd0-1dca-4dfc-9b5c-a0cd14d2f994","name":"Calf Raises","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]}]}],"wednesday":[{"id":"10308475-635e-4697-a962-801893c577f6","name":"Back + Biceps","exercises":[{"id":"5f274dbe-7509-4f7f-aae1-85fffddd845b","name":"Rowing","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"54a0594f-166c-422e-9cf6-b6ea0013be8d","name":"Lat Pulldown","sets":[{"repetitions":12},{"repetitions":10},{"repetitions":10}]},{"id":"aec821a9-9c24-4cb2-b508-d1c29d16cb7e","name":"Bent Over Flies","sets":[{"repetitions":10},{"repetitions":10},{"repetitions":10}]},{"id":"6466c1ab-a634-4af4-bc47-5cd8b71489e5","name":"Barbell Curls","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]},{"id":"ec8a7890-5f8e-40f7-a806-a0d90c25f4ce","name":"Hammer Curls","sets":[{"repetitions":12},{"repetitions":12},{"repetitions":12}]}]}]},"createdOn":"2023-02-16T00:00:00.000Z","accountId":"a28VMwRLc6Z89RENj3q3dQySEoJ3"}],"alreadyUpToDate":false}';

void main() {
  group('Email Validation', () {
    test('Email should be valid', () {
      ReadAccountDto.fromJson(jsonDecode(jsonResult));
    });
  });
}
