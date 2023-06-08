# Надання кредитів

*Інформаційна система призначена для обліку надання та повернення кредитів.*

Кожен клієнт має номер особового рахунку, назву, податковий код, юридичну та фактичну адреси, П.І.П керівника (або уповноваженої особи), рейтинг. Клієнти користуються кредитами у відповідності до укладених з ними договорів, які характеризуються унікальним номером кредитного договору, датою укладання договору, сумою, строком, річною процентною ставкою, типом графіка погашення та заставою. Графік погашення включає дату платежу, суму погашення основного боргу та суму нарахованих за останній період процентів.

Система повинна зберігати встановлений графік погашення, вести облік виданих і повернених коштів та нараховувати проценти за користування кредитом. Проценти за користування кредитом нараховуються щомісяця на залишок суми кредиту. Якщо клієнт не розраховується вчасно (згідно графіка), йому нараховується пеня з розрахунку 1% від залишку за кожен день прострочення платежу. Якщо клієнт не встиг розрахуватися до закінчення строку дії кредитного договору, то через 10 днів йому нараховується одноразова пеня в розмірі 15% від загальної суми заборгованості (включаючи нараховані на цей момент проценти). Нарахування процентів припиняється лише після того, як клієнт повністю розрахується по кредиту.

Система повинна вираховувати рейтинг кожного клієнта. Для обчислення рейтингу має застосовуватися формула:
![image](https://github.com/Vlad1kent1/DB-Credit/assets/111977759/e6b31a5c-dd0b-469c-9c12-d1cb4e52f9de)

де S – сума кредиту, D – строк договору у днях, Dфакт – фактичний строк користування кредитом у днях, Sзал – сума залишку, Pфакт – фактично сплачені проценти, ![image](https://github.com/Vlad1kent1/DB-Credit/assets/111977759/949e07d5-c068-42c0-b5fc-4595e2982613) – сума днів випередження графіка платежів, ![image](https://github.com/Vlad1kent1/DB-Credit/assets/111977759/1c9498f5-9a58-4ef5-be8a-a44b8affd2b2) – сума днів прострочення платежів за графіком. Рейтинг повинен обчислюватися та вноситися у таблицю для заданого клієнта на останню з двох дат: перше число місяця або дата останнього платежу.
Клієнт не може отримувати нові кредити у таких випадках: 1) якщо він мав коли-небудь прострочений кредит, тобто не розрахувався до закінчення строку дії договору; 2) якщо він порушує графік планових платежів за ще діючим кредитом; 3) якщо він має діючий кредит, по якому сума залишку разом з нарахованими йому процентами менша, ніж сума кредиту, яку він хоче одержати; 4) якщо за рейтингом він потрапляє у останню чверть рейтингового списку.

![image](https://github.com/Vlad1kent1/DB-Credit/assets/111977759/9151b9a7-28bb-44e0-a3ef-7d1e380c8a19)
